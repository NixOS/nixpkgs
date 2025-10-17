{
  buildVersion,
  dev ? false,
  aarch64sha256,
  x64sha256,
}:

{
  fetchurl,
  stdenv,
  lib,
  xorg,
  glib,
  libglvnd,
  glibcLocales,
  gtk3,
  cairo,
  pango,
  makeWrapper,
  wrapGAppsHook3,
  writeShellScript,
  common-updater-scripts,
  curl,
  openssl_1_1,
  bzip2,
  sqlite,
}:

let
  pnameBase = "sublimetext4";
  packageAttribute = "sublime4${lib.optionalString dev "-dev"}";
  binaries = [
    "sublime_text"
    "plugin_host-3.3"
    "plugin_host-3.8"
    crashHandlerBinary
  ];
  primaryBinary = "sublime_text";
  primaryBinaryAliases = [
    "subl"
    "sublime"
    "sublime4"
  ];
  crashHandlerBinary =
    if lib.versionAtLeast buildVersion "4153" then "crash_handler" else "crash_reporter";
  downloadUrl =
    arch: "https://download.sublimetext.com/sublime_text_build_${buildVersion}_${arch}.tar.xz";
  versionUrl = "https://download.sublimetext.com/latest/${if dev then "dev" else "stable"}";
  versionFile = toString ./packages.nix;

  neededLibraries = [
    xorg.libX11
    xorg.libXtst
    glib
    libglvnd
    openssl_1_1
    gtk3
    cairo
    pango
    curl
  ]
  ++ lib.optionals (lib.versionAtLeast buildVersion "4145") [
    sqlite
  ];

  binaryPackage = stdenv.mkDerivation rec {
    pname = "${pnameBase}-bin";
    version = buildVersion;

    src = passthru.sources.${stdenv.hostPlatform.system};

    dontStrip = true;
    dontPatchELF = true;

    buildInputs = [
      glib
      # for GSETTINGS_SCHEMAS_PATH
      gtk3
    ];

    nativeBuildInputs = [
      makeWrapper
      wrapGAppsHook3
    ];

    buildPhase = ''
      runHook preBuild

      for binary in ${builtins.concatStringsSep " " binaries}; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${lib.makeLibraryPath neededLibraries}:${lib.getLib stdenv.cc.cc}/lib${lib.optionalString stdenv.hostPlatform.is64bit "64"} \
          $binary
      done

      # Rewrite pkexec argument. Note that we cannot delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' ${primaryBinary}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # No need to patch these libraries, it works well with our own
      rm libcrypto.so.1.1 libssl.so.1.1
      ${lib.optionalString (lib.versionAtLeast buildVersion "4145") "rm libsqlite3.so"}

      mkdir -p $out
      cp -r * $out/

      runHook postInstall
    '';

    dontWrapGApps = true; # non-standard location, need to wrap the executables manually

    postFixup = ''
      sed -i 's#/usr/bin/pkexec#pkexec\x00\x00\x00\x00\x00\x00\x00\x00\x00#g' "$out/${primaryBinary}"

      wrapProgram $out/${primaryBinary} \
        --set LOCALE_ARCHIVE "${glibcLocales.out}/lib/locale/locale-archive" \
        "''${gappsWrapperArgs[@]}"
    '';

    passthru = {
      sources = {
        "aarch64-linux" = fetchurl {
          url = downloadUrl "arm64";
          sha256 = aarch64sha256;
        };
        "x86_64-linux" = fetchurl {
          url = downloadUrl "x64";
          sha256 = x64sha256;
        };
      };
    };
  };
in
stdenv.mkDerivation rec {
  pname = pnameBase;
  version = buildVersion;

  dontUnpack = true;

  ${primaryBinary} = binaryPackage;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "''$${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
  ''
  + builtins.concatStringsSep "" (
    map (binaryAlias: "ln -s $out/bin/${primaryBinary} $out/bin/${binaryAlias}\n") primaryBinaryAliases
  )
  + ''
    mkdir -p "$out/share/applications"

    substitute \
      "''$${primaryBinary}/${primaryBinary}.desktop" \
      "$out/share/applications/${primaryBinary}.desktop" \
      --replace-fail "/opt/${primaryBinary}/${primaryBinary}" "${primaryBinary}"

    for directory in ''$${primaryBinary}/Icon/*; do
      size=$(basename $directory)
      mkdir -p "$out/share/icons/hicolor/$size/apps"
      ln -s ''$${primaryBinary}/Icon/$size/* $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru = {
    updateScript =
      let
        script = writeShellScript "${packageAttribute}-update-script" ''
          set -o errexit
          PATH=${
            lib.makeBinPath [
              common-updater-scripts
              curl
            ]
          }

          versionFile=$1
          latestVersion=$(curl -s "${versionUrl}")

          if [[ "${buildVersion}" = "$latestVersion" ]]; then
              echo "The new version same as the old version."
              exit 0
          fi

          for platform in ${lib.escapeShellArgs meta.platforms}; do
              update-source-version "${packageAttribute}.${primaryBinary}" "$latestVersion" --ignore-same-version --file="$versionFile" --version-key=buildVersion --source-key="sources.$platform"
          done
        '';
      in
      [
        script
        versionFile
      ];
  };

  meta = with lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = "https://www.sublimetext.com/";
    maintainers = with maintainers; [
      jtojnar
      wmertens
      demin-dmitriy
      zimbatm
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
