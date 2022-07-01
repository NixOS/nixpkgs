{ buildVersion, aarch64sha256, x64sha256, dev ? false }:

{ fetchurl, stdenv, lib, xorg, glib, libglvnd, glibcLocales, gtk3, cairo, pango, makeWrapper, wrapGAppsHook
, writeShellScript, common-updater-scripts, curl
, openssl, bzip2, bash, unzip, zip
}:

let
  pname = "sublimetext4";
  packageAttribute = "sublime4${lib.optionalString dev "-dev"}";
  binaries = [ "sublime_text" "plugin_host-3.3" "plugin_host-3.8" "crash_reporter" ];
  primaryBinary = "sublime_text";
  primaryBinaryAliases = [ "subl" "sublime" "sublime4" ];
  downloadUrl = "https://download.sublimetext.com/sublime_text_build_${buildVersion}_${arch}.tar.xz";
  versionUrl = "https://download.sublimetext.com/latest/${if dev then "dev" else "stable"}";
  versionFile = builtins.toString ./packages.nix;
  archSha256 = {
    "aarch64-linux" = aarch64sha256;
    "x86_64-linux" = x64sha256;
  }.${stdenv.hostPlatform.system};
  arch = {
    "aarch64-linux" = "arm64";
    "x86_64-linux" = "x64";
  }.${stdenv.hostPlatform.system};

  libPath = lib.makeLibraryPath [ xorg.libX11 xorg.libXtst glib libglvnd openssl gtk3 cairo pango curl ];
in let
  binaryPackage = stdenv.mkDerivation {
    pname = "${pname}-bin";
    version = buildVersion;

    src = fetchurl {
      url = downloadUrl;
      sha256 = archSha256;
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ glib gtk3 ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ zip unzip makeWrapper wrapGAppsHook ];

    # make exec.py in Default.sublime-package use own bash with an LD_PRELOAD instead of "/bin/bash"
    patchPhase = ''
      runHook prePatch

      # TODO: Should not be necessary even in 3
      mkdir Default.sublime-package-fix
      ( cd Default.sublime-package-fix
        unzip -q ../Packages/Default.sublime-package
        substituteInPlace "exec.py" --replace \
          "[\"/bin/bash\"" \
          "[\"$out/sublime_bash\""
        zip -q ../Packages/Default.sublime-package **/*
      )
      rm -r Default.sublime-package-fix

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      for binary in ${ builtins.concatStringsSep " " binaries }; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${lib.optionalString stdenv.is64bit "64"} \
          $binary
      done

      # Rewrite pkexec argument. Note that we cannot delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' ${primaryBinary}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out/

      # We can't just call /usr/bin/env bash because a relocation error occurs
      # when trying to run a build from within Sublime Text
      ln -s ${bash}/bin/bash $out/sublime_bash

      runHook postInstall
    '';

    dontWrapGApps = true; # non-standard location, need to wrap the executables manually

    postFixup = ''
      sed -i 's#/usr/bin/pkexec#pkexec\x00\x00\x00\x00\x00\x00\x00\x00\x00#g' "$out/${primaryBinary}"

      wrapProgram $out/${primaryBinary} \
        --set LOCALE_ARCHIVE "${glibcLocales.out}/lib/locale/locale-archive" \
        "''${gappsWrapperArgs[@]}"
    '';
  };
in stdenv.mkDerivation (rec {
  inherit pname;
  version = buildVersion;

  dontUnpack = true;

  ${primaryBinary} = binaryPackage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "''$${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
  '' + builtins.concatStringsSep "" (map (binaryAlias: "ln -s $out/bin/${primaryBinary} $out/bin/${binaryAlias}\n") primaryBinaryAliases) + ''
    mkdir -p "$out/share/applications"
    substitute "''$${primaryBinary}/${primaryBinary}.desktop" "$out/share/applications/${primaryBinary}.desktop" --replace "/opt/${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
    for directory in ''$${primaryBinary}/Icon/*; do
      size=$(basename $directory)
      mkdir -p "$out/share/icons/hicolor/$size/apps"
      ln -s ''$${primaryBinary}/Icon/$size/* $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru.updateScript = writeShellScript "${pname}-update-script" ''
    set -o errexit
    PATH=${lib.makeBinPath [ common-updater-scripts curl ]}

    latestVersion=$(curl -s ${versionUrl})

    if [[ "${buildVersion}" = "$latestVersion" ]]; then
        echo "The new version same as the old version."
        exit 0
    fi

    for platform in ${lib.concatStringsSep " " meta.platforms}; do
        # The script will not perform an update when the version attribute is up to date from previous platform run
        # We need to clear it before each run
        update-source-version ${packageAttribute}.${primaryBinary} 0 0000000000000000000000000000000000000000000000000000000000000000 --file=${versionFile} --version-key=buildVersion --system=$platform
        update-source-version ${packageAttribute}.${primaryBinary} $latestVersion --file=${versionFile} --version-key=buildVersion --system=$platform
    done
  '';

  meta = with lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = "https://www.sublimetext.com/";
    maintainers = with maintainers; [ jtojnar wmertens demin-dmitriy zimbatm ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
})
