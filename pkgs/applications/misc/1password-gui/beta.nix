{ lib
, stdenv
, fetchurl
, makeWrapper
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, libdrm
, libxcb
, libxkbcommon
, libxshmfence
, libGL
, libappindicator-gtk3
, mesa
, nspr
, nss
, pango
, systemd
, udev
, xdg-utils

  # The 1Password polkit file requires a list of users for whom polkit
  # integrations should be enabled. This should be a list of strings that
  # correspond to usernames.
, polkitPolicyOwners ? []
}:
let
  # Convert the polkitPolicyOwners variable to a polkit-compatible string for the polkit file.
  policyOwners = lib.concatStringsSep " " (map (user: "unix-user:${user}") polkitPolicyOwners);

in stdenv.mkDerivation rec {
  pname = "1password";
  version = "8.8.0-215.BETA";

  src =
    if stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-GjLwLeJ6GE39NFIZ+v83xaUVsgrkKRH3xt60aG/XrDg=";
      }
    else
      fetchurl {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-TR0evvu5NNR6Kvqj8JlpYuTcK9Rmf1oDFGrfzrGZzo8=";
      };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase =
    let rpath = lib.makeLibraryPath [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libdrm
      libxcb
      libxkbcommon
      libxshmfence
      libGL
      libappindicator-gtk3
      mesa
      nspr
      nss
      pango
      systemd
    ] + ":${stdenv.cc.cc.lib}/lib64";
    in ''
      runHook preInstall

      mkdir -p $out/bin $out/share/1password
      cp -a * $out/share/1password

      # Desktop file
      install -Dt $out/share/applications resources/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=/opt/1Password/${pname}' 'Exec=${pname}'

      '' + (lib.optionalString (polkitPolicyOwners != [ ])
      ''
      # Polkit file
        mkdir -p $out/share/polkit-1/actions
        substitute com.1password.1Password.policy.tpl $out/share/polkit-1/actions/com.1password.1Password.policy --replace "\''${POLICY_OWNERS}" "${policyOwners}"
        '') + ''

      # Icons
      cp -a resources/icons $out/share

      interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
      patchelf --set-interpreter $interp $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper}
      patchelf --set-rpath ${rpath}:$out/share/1password $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper}
      for file in $(find $out -type f -name \*.so\* ); do
        patchelf --set-rpath ${rpath}:$out/share/1password $file
      done

      # Electron is trying to open udev via dlopen()
      # and for some reason that doesn't seem to be impacted from the rpath.
      # Adding udev to LD_LIBRARY_PATH fixes that.
      makeWrapper $out/share/1password/1password $out/bin/1password \
        --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}

      runHook postInstall
    '';

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ timstott savannidgerinel maxeaubrey sebtm ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
