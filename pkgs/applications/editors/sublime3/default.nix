{ fetchurl, stdenv, glib, xorg, cairo, gtk2, pango, makeWrapper, openssl, bzip2,
  pkexecPath ? "/run/wrappers/bin/pkexec", libredirect,
  gksuSupport ? false, gksu, unzip, zip, bash }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
assert gksuSupport -> gksu != null;

let
  build = "3143";
  libPath = stdenv.lib.makeLibraryPath [glib xorg.libX11 gtk2 cairo pango];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ]
    ++ stdenv.lib.optional gksuSupport "/usr/bin/gksudo=${gksu}/bin/gksudo";
in let
  # package with just the binaries
  sublime = stdenv.mkDerivation {
    name = "sublimetext3-${build}-bin";

    src =
      if stdenv.system == "i686-linux" then
        fetchurl {
          name = "sublimetext-${build}.tar.bz2";
          url = "https://download.sublimetext.com/sublime_text_3_build_${build}_x32.tar.bz2";
          sha256 = "0dgpx4wij2m77f478p746qadavab172166bghxmj7fb61nvw9v5i";
        }
      else
        fetchurl {
          name = "sublimetext-${build}.tar.bz2";
          url = "https://download.sublimetext.com/sublime_text_3_build_${build}_x64.tar.bz2";
          sha256 = "06b554d2cvpxc976rvh89ix3kqc7klnngvk070xrs8wbyb221qcw";
        };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ makeWrapper zip unzip ];

    # make exec.py in Default.sublime-package use own bash with
    # an LD_PRELOAD instead of "/bin/bash"
    patchPhase = ''
      mkdir Default.sublime-package-fix
      ( cd Default.sublime-package-fix
        unzip -q ../Packages/Default.sublime-package
        substituteInPlace "exec.py" --replace \
          "[\"/bin/bash\"" \
          "[\"$out/sublime_bash\""
        zip -q ../Packages/Default.sublime-package **/*
      )
      rm -r Default.sublime-package-fix
    '';

    buildPhase = ''
      for i in sublime_text plugin_host crash_reporter; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $i
      done

      # Rewrite pkexec|gksudo argument. Note that we can't delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' sublime_text
    '';

    installPhase = ''
      # Correct sublime_text.desktop to exec `sublime' instead of /opt/sublime_text
      sed -e "s,/opt/sublime_text/sublime_text,$out/sublime_text," -i sublime_text.desktop

      mkdir -p $out
      cp -prvd * $out/

      # We can't just call /usr/bin/env bash because a relocation error occurs
      # when trying to run a build from within Sublime Text
      ln -s ${bash}/bin/bash $out/sublime_bash
      wrapProgram $out/sublime_bash \
        --set LD_PRELOAD "${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1"

      wrapProgram $out/sublime_text \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects}

      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram $out/plugin_host --prefix LD_PRELOAD : ${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1:${openssl.out}/lib/libssl.so:${bzip2.out}/lib/libbz2.so
    '';
  };
in stdenv.mkDerivation {
  name = "sublimetext3-${build}";

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
    platforms = platforms.linux;
  };
}
