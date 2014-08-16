{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gconf, nss, xlibs
}:

let
  atomEnv = buildEnv {
    name = "env-atom";
    paths = [
      stdenv.gcc.gcc zlib glib dbus gtk atk pango freetype libgnome_keyring3
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
      xlibs.libXrender xlibs.libX11 xlibs.libXext xlibs.libXdamage xlibs.libXtst
      xlibs.libXcomposite xlibs.libXi xlibs.libXfixes
    ];
  };
in stdenv.mkDerivation rec {
  name = "atom-${version}";
  version = "0.99.0";

  src = fetchurl {
      url = https://github.com/hotice/webupd8/raw/master/atom-linux64-0.99.0~git20140525.tar.xz;
      sha256 = "55c2415c96e1182ae1517751cbea1db64e9962683b384cfe5e182aec10aebecd";
      name = "${name}.tar.xz";
  };

  iconsrc = fetchurl {
    url = https://raw.githubusercontent.com/atom/atom/master/resources/atom.png;
    sha256 = "66dc0b432eed7bcd738b7c1b194e539178a83d427c78f103041981f2b840e030";
  };

  desktopItem = makeDesktopItem {
    name = "atom";
    exec = "atom";
    icon = iconsrc;
    comment = "A hackable text editor for the 21st Century";
    desktopName = "Atom";
    genericName = "Text editor";
    categories = "Development;TextEditor";
  };

  buildInputs = [ atomEnv makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/atom
    mkdir -p $out/bin
    tar -C $out/share/atom -xvf $src
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      $out/share/atom/atom
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      $out/share/atom/resources/app/apm/node_modules/atom-package-manager/bin/node
    makeWrapper $out/share/atom/atom $out/bin/atom \
      --prefix "LD_LIBRARY_PATH" : "${atomEnv}/lib:${atomEnv}/lib64"

    # Create a desktop item.
    mkdir -p "$out/share/applications"
    cp "${desktopItem}"/share/applications/* "$out/share/applications/"  
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = [ licenses.mit ];
    maintainers = [ maintainers.offline ];
    platforms = [ "x86_64-linux" ];
  };
}
