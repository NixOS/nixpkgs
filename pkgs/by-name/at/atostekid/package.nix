{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  findutils,
  firefox,
  util-linux,
  gnused,
  gnugrep,
  coreutils,
  nss,
  pcsclite,
  qt6,
  libjpeg8,
  minizip,
  bash,
  testers,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "atostekid";
  version = "4.5.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  # Download from https://dvv.fi/en/linux-versions
  src = fetchurl {
    url = "https://files.fineid.fi/download/atostek/${version}/linux/AtostekID_DEB_${version}.deb";
    hash = "sha256-wxFEWlaVFnBWJcEkJlOlzH7PofYWlG1nW+9xAAJ0oL8=";
  };

  nativeBuildInputs = [
    dpkg # for unpacking
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    nss
    pcsclite
    qt6.qtbase

    libjpeg8
    minizip

    bash # required for patchShebangs
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    # etc contains only "etc/dconf/db/local.d/00-extensions-atostekid" with the Ubuntu GNOME AppIndicator extension; skip it
    cp -r usr/bin $out
    cp -r usr/lib $out
    cp -r usr/share $out

    # Link PKCS#11 module to standard location
    mkdir $out/lib/pkcs11
    ln -s $out/lib/{,pkcs11/}Atostek-ID-PKCS11.so

    mkdir -p $out/share/p11-kit/modules
    # Note that p11-kit does not currently read configs using $XDG_DATA_DIRS so this file is ignored by default when installed into /run/current-system/sw/share.
    echo "module: $out/lib/pkcs11/Atostek-ID-PKCS11.so" > $out/share/p11-kit/modules/atostekid.module

    runHook postInstall
  '';

  preFixup = ''
    pushd $out/lib/atostekid/

    # The bundled libcrypto.so.3 (3.3.2) is required because the binary has OpenSSL 3.3.2 compiled in.
    # Rename its SONAME so it doesn't collide with Nixpkgs's libcrypto (3.6.x) required by Qt6's TLS backend.
    patchelf --set-soname libcrypto_atostekid.so.3 libcrypto.so.3
    mv libcrypto.so.3 libcrypto_atostekid.so.3
    patchelf --replace-needed libcrypto.so.3 libcrypto_atostekid.so.3 libqpdf.so.29

    # Add a NEEDED entry so the renamed library satisfies the symbols instead of the one from Nixpkgs.
    patchelf --add-needed libcrypto_atostekid.so.3 $out/bin/atostekid

    # Use Nixpkgs versions
    rm libjpeg.so.8 \
       libminizip.so \
       libz.so.1.3.1

    popd
  '';

  postFixup = ''
    # /etc/AtostekIDConfig is optional so don't die when it's missing
    substituteInPlace $out/bin/atostekid-setup-user-browser.sh \
      --replace-fail 'parse_config_file /etc/AtostekIDConfig' \
                      'parse_config_file /etc/AtostekIDConfig || true'

    # Split on nulls to handle paths with spaces (e.g. profile names)
    substituteInPlace $out/bin/atostekid-setup-user-browser.sh \
      --replace-fail 'set -- $(''${FIND_BIN} $firefox_dirs -maxdepth 4 -type f -regex ".*cert[0-9]\.db" 2>/dev/null)' \
                      'mapfile -d "" temp_array < <(''${FIND_BIN} $firefox_dirs -maxdepth 4 -type f -regex ".*cert[0-9]\.db" -print0 2>/dev/null) ; set -- "''${temp_array[@]}"'

    # Add `.config/mozilla` to list of standard paths
    substituteInPlace $out/bin/atostekid-setup-user-browser.sh \
      --replace-fail '"''${HOME_DIR}/.mozilla" \' '"''${HOME_DIR}/.mozilla" "''${XDG_CONFIG_HOME:-''${HOME_DIR}/.config}/mozilla" \'

    # Wrap the script with dependencies
    wrapProgram $out/bin/atostekid-setup-user-browser.sh \
      --set ATOSTEK_ID_BIN "$out/bin/atostekid" \
      --set CERTUTIL_BIN "${nss.tools}/bin/certutil" \
      --set FIND_BIN "${findutils}/bin/find" \
      --prefix PATH : "${
        lib.makeBinPath [
          util-linux
          gnugrep
          gnused
          coreutils
        ]
      }"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "atostekid";
      type = "Application";
      desktopName = "Atostek ID";
      genericName = "Card Reader Software";
      comment = "Authenticate and sign documents using your Finnish ID card (citizen certificate)";
      exec = finalAttrs.meta.mainProgram;
      categories = [
        "Utility"
        "Security"
        "Qt"
      ];

      extraConfig."GenericName[fi]" = "Kortinlukijaohjelmisto";
      extraConfig."Comment[fi]" =
        "Tunnistaudu ja allekirjoita asiakirjoja suomalaisella henkilökortillasi (kansalaisvarmenteella)";
    })
  ];

  passthru.tests.p11-kit = testers.runNixOSTest {
    name = "atostekid-p11-kit";
    containers.machine =
      { pkgs, ... }:
      {
        # Enable PC/SC Smart Card Daemon
        services.pcscd.enable = true;

        # Tell p11-kit to load/proxy Atostek ID
        environment.etc."pkcs11/modules/atostekid.module".source =
          "${finalAttrs.finalPackage}/share/p11-kit/modules/atostekid.module";

        environment.systemPackages = [
          pkgs.p11-kit
        ];
      };
    testScript = ''
      machine.succeed("p11-kit list-modules | grep atostekid")
      machine.fail("p11-kit list-modules | grep \"couldn't load module info\"")
    '';
  };

  passthru.tests.user-setup-browser-help = testers.runCommand {
    name = "atostekid-user-setup-browser-help";
    script = ''
      ${lib.getExe' finalAttrs.finalPackage "atostekid-setup-user-browser.sh"} --help > /dev/null
      touch $out
    '';
  };
  passthru.tests.user-setup-browser = testers.runCommand {
    name = "atostekid-user-setup-browser";
    script = ''
      export HOME=$TMPDIR
      ${lib.getExe' finalAttrs.finalPackage "atostekid-setup-user-browser.sh"}
      touch $out
    '';
  };

  passthru.tests.user-setup-browser-firefox = testers.runCommand {
    name = "atostekid-user-setup-browser-firefox";
    script = ''
      export HOME=$(mktemp -d)
      export XDG_CONFIG_HOME=$HOME/.config2
      TEST_PROF_DIR="$XDG_CONFIG_HOME/mozilla/firefox/test with space.default"

      # Create a Firefox profile
      ${lib.getExe firefox} --headless --createprofile "test $TEST_PROF_DIR" > /dev/null 2>&1
      # Launch it so it generates the NSS database (cert9.db)
      ${lib.getExe firefox} --headless --profile "$TEST_PROF_DIR" about:blank > /dev/null 2>&1 &
      FF_PID=$!
      for _ in {1..30}; do
        [ -f "$TEST_PROF_DIR/cert9.db" ] && break
        sleep 1
      done
      kill $FF_PID 2>/dev/null || true
      wait $FF_PID 2>/dev/null || true
      [ -f "$TEST_PROF_DIR/cert9.db" ] || {
        echo "Firefox did not create cert9.db" >&2
        exit 1
      }

      # Install the CAs into the profile
      ${lib.getExe' finalAttrs.finalPackage "atostekid-setup-user-browser.sh"}

      # Verify the CAs landed in the profile's trust store
      ${lib.getExe' nss.tools "certutil"} -d sql:"$TEST_PROF_DIR" -L \
        | grep -qE 'AID-SCSCA'
      ${lib.getExe' nss.tools "certutil"} -d sql:"$TEST_PROF_DIR" -L \
        | grep -qE 'AID-ERASMARTCARD-EHOITO-FI-CA'

      touch $out
    '';
  };

  meta = {
    description = "Desktop application for Finnish electronic ID cards";
    longDescription = ''
      Authenticate and sign documents using your Finnish ID card (citizen certificate).

      To use Suomi.fi authentication, only PKCS#11 needs to be enabled. Add the following to your NixOS configuration to enable that in Firefox:

      ```nix
      { pkgs, ... }:
      {
        # Enable PC/SC Smart Card Daemon
        services.pcscd.enable = true;

        # Tell p11-kit to load/proxy Atostek ID
        environment.etc."pkcs11/modules/atostekid.module".source = "''${pkgs.atostekid}/share/p11-kit/modules/atostekid.module";

        # Tell Firefox to use p11-kit
        programs.firefox = {
          enable = true;
          policies.SecurityDevices.Add.p11-kit-proxy = "''${pkgs.p11-kit}/lib/p11-kit-proxy.so";
        };

        # Install the system tray application
        environment.systemPackages = [
          pkgs.atostekid
        ];
      }
      ```
    '';
    mainProgram = "atostekid";
    homepage = "https://dvv.fi/en/linux-versions";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ axka ];
  };
})
