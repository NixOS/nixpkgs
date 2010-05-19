{ stdenv, fetchurl, patchelf, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jre
 # defaulting to this version because not all installable plugins work with 3.5.2 yet
 # can also be set to "latest"
, version ? "3.5.1"
}:

/*
  Note: Eclipse stores various Eclipse instance specific data in ~/.eclipse/*-instance/...
  The '*' depends on the executable location of Eclipse.

  So if an Eclipse dependency such as gtk changes a different Eclipse setup directory will be used and
  the plugins and update site list and more global settings seem to be gone.

  Staring Eclipse from ~/.nix-profile/bin/eclipse doesn't help.

  So I suggest copying the store path to ~/eclipse and run ~/eclipse/bin/eclipse instead.

  However this still has some drawbacks: If you run nix-collect-garbage the gtk
  libs the wrapper refers to might be gone. It should be easy for you to
  replace the imortant lines in the wrapper.

  You can also put this eclipse wrapper script (which was removed from
  all-packages.nix -r 18458)
  to your packageOverrides section and use that to run eclipse/eclipse.

  Its parameterized by system because you may want to run both: i686 and x86_64 systems.

    eclipseRunner =
      pkgs.stdenv.mkDerivation {
      name = "nix-eclipse-runner-script-${stdenv.system}";

      phases = "installPhase";
      installPhase = ''
        ensureDir $out/bin
        target=$out/bin/nix-run-eclipse-${stdenv.system}
        cat > $target << EOF
        #!/bin/sh
        export PATH=${pkgs.jre}/bin:\$PATH
        export LD_LIBRARY_PATH=${pkgs.gtkLibs216.glib}/lib:${pkgs.gtkLibs216.gtk}/lib:${pkgs.xlibs.libXtst}/lib
        # If you run out of XX space try these? -vmargs -Xms512m -Xmx2048m -XX:MaxPermSize=256m
        eclipse="\$1"; shift
        exec \$eclipse -vmargs -Xms512m -Xmx2048m -XX:MaxPermSize=256m "\$@"
        EOF
        chmod +x $target
      '';

      meta = {
        description = "provide environment to run Eclipse";
        longDescription = ''
          Is there one distribution providing support for up to date Eclipse installations?
          There are various reasons why not.
          Installing binaries just works. Get Eclipse binaries form eclipse.org/downloads
          install this wrapper then run Eclipse like this:
          nix-run-eclipse $PATH_TO_ECLIPSE/eclipse/eclipse
          and be happy. Everything works including update sites.
        '';
        maintainers = [pkgs.lib.maintainers.marcweber];
        platforms = pkgs.lib.platforms.linux;
      };
    };

*/


let

  v = if version == "latest" then "3.5.2" else version;

in

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "eclipse-${v}";
  
  src =
    if v == "3.5.2" then
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk-x86_64.tar.gz;
          md5 = "54e2ce0660b2b1b0eb4267acf70ea66d";
        }
      else
        fetchurl {
          url = http://mirror.selfnet.de/eclipse/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk.tar.gz;
          md5 = "bde55a2354dc224cf5f26e5320e72dac";
        }
    else if v == "3.5.1" then
     if stdenv.system == "x86_64-linux" then
       fetchurl {
        url = http://ftp.ing.umu.se/mirror/eclipse/eclipse/downloads/drops/R-3.5.1-200909170800/eclipse-SDK-3.5.1-linux-gtk-x86_64.tar.gz;
        sha256 = "132zd7q9q29h978wnlsfbrlszc85r1wj30yqs2aqbv3l5xgny1kk";
       }
     else
       fetchurl {
        url = http://mirrors.linux-bg.org/eclipse/eclipse/downloads/drops/R-3.5.1-200909170800/eclipse-SDK-3.5.1-linux-gtk.tar.gz;
        sha256 = "0a0lpa7gxg91zswpahi6fvg3csl4csvlym4z2ad5cc1d4yvicp56";
      }
    else throw "no source for eclipse version ${v} known";

  desktopItem = makeDesktopItem {
    name = "Eclipse";
    exec = "eclipse";
    icon = "eclipse";
    comment = "Integrated Development Environment";
    desktopName = "Eclipse IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };

  buildInputs = [ makeWrapper patchelf ];
  
  buildCommand = ''
    # Unpack tarball
    ensureDir $out
    tar xfvz $src -C $out
    
    # Patch binaries
    interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
    patchelf --set-interpreter $interpreter $out/eclipse/eclipse
    patchelf --set-rpath ${freetype}/lib:${fontconfig}/lib:${libX11}/lib:${libXrender}/lib:${zlib}/lib $out/eclipse/libcairo-swt.so

    # Create wrapper script
    makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib
    
    # Create desktop item
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    homepage = http://www.eclipse.org/;
    description = "A extensible multi-language software development environment";
    longDescription = ''
    '';
  };
}
