{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gconf, nss, xlibs, libcap
}:

let
  atomEnv = buildEnv {
    name = "env-atom";
    paths = [
      stdenv.gcc.gcc zlib glib dbus gtk atk pango freetype libgnome_keyring3
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
      xlibs.libXrender xlibs.libX11 xlibs.libXext xlibs.libXdamage xlibs.libXtst
      xlibs.libXcomposite xlibs.libXi xlibs.libXfixes xlibs.libXrandr
      xlibs.libXcursor libcap
    ];
  };
in stdenv.mkDerivation rec {
  name = "atom-${version}";
  version = "0.135.0";

  src = fetchurl {
    url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
    sha256 = "0dh8vjhr31y2ibnf4s7adskbx115w8ns9xgrb0md9xc9gm92h405";
    name = "${name}.deb";
  };

  buildInputs = [ atomEnv makeWrapper ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    ar p $src data.tar.gz | tar -C $out -xz ./usr
    mv $out/usr/* $out/
    rm -r $out/usr/
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      $out/share/atom/atom
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      $out/share/atom/resources/app/apm/node_modules/atom-package-manager/bin/node
    wrapProgram $out/bin/atom \
      --prefix "LD_LIBRARY_PATH" : "${atomEnv}/lib:${atomEnv}/lib64"
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = [ licenses.mit ];
    maintainers = [ maintainers.offline ];
    platforms = [ "x86_64-linux" ];
  };
}
