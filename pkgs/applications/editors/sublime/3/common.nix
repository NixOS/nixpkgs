{ buildVersion, x32sha256, x64sha256, dev ? false }:

{ fetchurl, stdenv, xorg, glib, glibcLocales, gtk2, gtk3, cairo, pango, libredirect, makeWrapper, wrapGAppsHook
, pkexecPath ? "/run/wrappers/bin/pkexec", gksuSupport ? false, gksu
, writeScript, common-updater-scripts, curl, gnugrep
, openssl, bzip2, bash, unzip, zip
}:

assert gksuSupport -> gksu != null;

let
  pname = "sublimetext3";
  packageAttribute = "sublime3${stdenv.lib.optionalString dev "-dev"}";
  binaries = [ "sublime_text" "plugin_host" "crash_reporter" ];
  primaryBinary = "sublime_text";
  primaryBinaryAliases = [ "subl" "sublime" "sublime3" ];
  downloadUrl = "https://download.sublimetext.com/sublime_text_3_build_${buildVersion}_${arch}.tar.bz2";
  downloadArchiveType = "tar.bz2";
  versionUrl = "https://www.sublimetext.com/${if dev then "3dev" else "3"}";
  versionFile = "pkgs/applications/editors/sublime/3/packages.nix";
  usesGtk2 = stdenv.lib.versionOlder buildVersion "3181";
  archSha256 =
    if stdenv.hostPlatform.system == "i686-linux" then
      x32sha256
    else
      x64sha256;
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then
      "x32"
    else
      "x64";

  libPath = stdenv.lib.makeLibraryPath [ xorg.libX11 glib (if usesGtk2 then gtk2 else gtk3) cairo pango ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ]
    ++ stdenv.lib.optional gksuSupport "/usr/bin/gksudo=${gksu}/bin/gksudo";
in let
  binaryPackage = stdenv.mkDerivation {
    pname = "${pname}-bin";
    version = buildVersion;

    src = fetchurl {
      name = "${pname}-bin-${buildVersion}.${downloadArchiveType}";
      url = downloadUrl;
      sha256 = archSha256;
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = stdenv.lib.optionals (!usesGtk2) [ glib gtk3 ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ zip unzip makeWrapper ] ++ stdenv.lib.optional (!usesGtk2) wrapGAppsHook;

    # make exec.py in Default.sublime-package use own bash with an LD_PRELOAD instead of "/bin/bash"
    patchPhase = ''
      runHook prePatch

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
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $binary
      done

      # Rewrite pkexec|gksudo argument. Note that we can't delete bytes in binary.
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
      wrapProgram $out/sublime_bash \
        --set LD_PRELOAD "${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"

      wrapProgram $out/${primaryBinary} \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        --set LOCALE_ARCHIVE "${glibcLocales.out}/lib/locale/locale-archive" \
        ${stdenv.lib.optionalString (!usesGtk2) ''"''${gappsWrapperArgs[@]}"''}

      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram $out/plugin_host --prefix LD_PRELOAD : ${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1:${openssl.out}/lib/libssl.so:${bzip2.out}/lib/libbz2.so
    '';
  };
in stdenv.mkDerivation (rec {
  inherit pname;
  version = buildVersion;

  phases = [ "installPhase" ];

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

  passthru.updateScript = writeScript "${pname}-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${stdenv.lib.makeBinPath [ common-updater-scripts curl gnugrep ]}

    latestVersion=$(curl -s ${versionUrl} | grep -Po '(?<=<p class="latest"><i>Version:</i> Build )([0-9]+)')

    for platform in ${stdenv.lib.concatStringsSep " " meta.platforms}; do
        # The script will not perform an update when the version attribute is up to date from previous platform run
        # We need to clear it before each run
        update-source-version ${packageAttribute}.${primaryBinary} 0 0000000000000000000000000000000000000000000000000000000000000000 --file=${versionFile} --version-key=buildVersion --system=$platform
        update-source-version ${packageAttribute}.${primaryBinary} $latestVersion --file=${versionFile} --version-key=buildVersion --system=$platform
    done
  '';

  meta = with stdenv.lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = https://www.sublimetext.com/;
    maintainers = with maintainers; [ wmertens demin-dmitriy zimbatm ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
})
