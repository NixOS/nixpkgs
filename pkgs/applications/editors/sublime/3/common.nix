{buildVersion, x32sha256, x64sha256}:

{ fetchurl, stdenv, glib, xorg, cairo, gtk2, gtk3, pango, makeWrapper, wrapGAppsHook, openssl, bzip2,
  pkexecPath ? "/run/wrappers/bin/pkexec", libredirect,
  gksuSupport ? false, gksu, unzip, zip, bash}:

assert gksuSupport -> gksu != null;

let
  legacy = stdenv.lib.versionOlder buildVersion "3181";
  libPath = stdenv.lib.makeLibraryPath [ glib xorg.libX11 (if legacy then gtk2 else gtk3) cairo pango ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ]
    ++ stdenv.lib.optional gksuSupport "/usr/bin/gksudo=${gksu}/bin/gksudo";
in let
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

  # package with just the binaries
  sublime = stdenv.mkDerivation {
    name = "sublimetext3-${buildVersion}-bin";
    src =
      fetchurl {
        name = "sublimetext-${buildVersion}.tar.bz2";
        url = "https://download.sublimetext.com/sublime_text_3_build_${buildVersion}_${arch}.tar.bz2";
        sha256 = archSha256;
      };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = stdenv.lib.optionals (!legacy) [ glib gtk3 ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ makeWrapper zip unzip ] ++ stdenv.lib.optional (!legacy) wrapGAppsHook;

    # make exec.py in Default.sublime-package use own bash with
    # an LD_PRELOAD instead of "/bin/bash"
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

      for i in sublime_text plugin_host crash_reporter; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $i
      done

      # Rewrite pkexec|gksudo argument. Note that we can't delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' sublime_text

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # Correct sublime_text.desktop to exec `sublime' instead of /opt/sublime_text
      sed -e "s,/opt/sublime_text/sublime_text,$out/sublime_text," -i sublime_text.desktop

      mkdir -p $out
      cp -prvd * $out/

      # We can't just call /usr/bin/env bash because a relocation error occurs
      # when trying to run a build from within Sublime Text
      ln -s ${bash}/bin/bash $out/sublime_bash

      runHook postInstall
    '';

    dontWrapGApps = true; # non-standard location, need to wrap the executables manually

    postFixup = ''
      wrapProgram $out/sublime_bash \
        --set LD_PRELOAD "${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"

      wrapProgram $out/sublime_text \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        ${stdenv.lib.optionalString (!legacy) ''"''${gappsWrapperArgs[@]}"''}

      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram $out/plugin_host --prefix LD_PRELOAD : ${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1:${openssl.out}/lib/libssl.so:${bzip2.out}/lib/libbz2.so
    '';
  };
in stdenv.mkDerivation (rec {
  name = "sublimetext3-${buildVersion}";

  phases = [ "installPhase" ];

  inherit sublime;

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/subl <<-EOF
    #!/bin/sh
    exec $sublime/sublime_text "\$@"
    EOF
    chmod +x $out/bin/subl

    ln $out/bin/subl $out/bin/sublime
    ln $out/bin/subl $out/bin/sublime3
    mkdir -p $out/share/applications
    ln -s $sublime/sublime_text.desktop $out/share/applications/sublime_text.desktop
    ln -s $sublime/Icon/256x256/ $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = https://www.sublimetext.com/;
    maintainers = with maintainers; [ wmertens demin-dmitriy zimbatm ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
})
