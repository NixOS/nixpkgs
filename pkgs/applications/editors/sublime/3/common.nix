{
  buildVersion,
  x32sha256,
  x64sha256,
  dev ? false,
}:

{
  fetchurl,
  lib,
  stdenv,
  xorg,
  glib,
  glibcLocales,
  gtk3,
  cairo,
  pango,
  libredirect,
  makeWrapper,
  wrapGAppsHook3,
  pkexecPath ? "/run/wrappers/bin/pkexec",
  openssl,
  bzip2,
  bash,
  unzip,
  zip,
}:

let
  pname = "sublimetext3";
  packageAttribute = "sublime3${lib.optionalString dev "-dev"}";
  binaries = [
    "sublime_text"
    "plugin_host"
    "crash_reporter"
  ];
  primaryBinary = "sublime_text";
  primaryBinaryAliases = [
    "subl"
    "sublime"
    "sublime3"
  ];
  downloadUrl = "https://download.sublimetext.com/sublime_text_3_build_${buildVersion}_${arch}.tar.bz2";
  versionUrl = "https://download.sublimetext.com/latest/${if dev then "dev" else "stable"}";
  versionFile = builtins.toString ./packages.nix;
  archSha256 = if stdenv.hostPlatform.system == "i686-linux" then x32sha256 else x64sha256;
  arch = if stdenv.hostPlatform.system == "i686-linux" then "x32" else "x64";

  libPath = lib.makeLibraryPath [
    xorg.libX11
    glib
    gtk3
    cairo
    pango
  ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ];
in
let
  binaryPackage = stdenv.mkDerivation {
    pname = "${pname}-bin";
    version = buildVersion;

    src = fetchurl {
      url = downloadUrl;
      sha256 = archSha256;
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [
      glib
      gtk3
    ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [
      zip
      unzip
      makeWrapper
      wrapGAppsHook3
    ];

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

      for binary in ${builtins.concatStringsSep " " binaries}; do
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
      wrapProgram $out/sublime_bash \
        --set LD_PRELOAD "${stdenv.cc.cc.lib}/lib${lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"

      wrapProgram $out/${primaryBinary} \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        --set LOCALE_ARCHIVE "${glibcLocales.out}/lib/locale/locale-archive" \
        "''${gappsWrapperArgs[@]}"

      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram $out/plugin_host --prefix LD_PRELOAD : ${stdenv.cc.cc.lib}/lib${lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1:${lib.getLib openssl}/lib/libssl.so:${bzip2.out}/lib/libbz2.so
    '';
  };
in
stdenv.mkDerivation (rec {
  inherit pname;
  version = buildVersion;

  dontUnpack = true;

  ${primaryBinary} = binaryPackage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    ''
      mkdir -p "$out/bin"
      makeWrapper "''$${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
    ''
    + builtins.concatStringsSep "" (
      map (binaryAlias: "ln -s $out/bin/${primaryBinary} $out/bin/${binaryAlias}\n") primaryBinaryAliases
    )
    + ''
      mkdir -p "$out/share/applications"
      substitute "''$${primaryBinary}/${primaryBinary}.desktop" "$out/share/applications/${primaryBinary}.desktop" --replace "/opt/${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
      for directory in ''$${primaryBinary}/Icon/*; do
        size=$(basename $directory)
        mkdir -p "$out/share/icons/hicolor/$size/apps"
        ln -s ''$${primaryBinary}/Icon/$size/* $out/share/icons/hicolor/$size/apps
      done
    '';

  meta = with lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = "https://www.sublimetext.com/";
    maintainers = with maintainers; [
      wmertens
      demin-dmitriy
      zimbatm
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
