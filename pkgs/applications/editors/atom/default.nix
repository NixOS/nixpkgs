{ stdenv, fetchurl, lib, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, gvfs, cairo, cups, expat, libgpgerror, nspr, gconf, nss, xorg, libcap, systemd
}:

let
  atomPkgs = [
    stdenv.cc.cc zlib glib dbus gtk atk pango freetype libgnome_keyring3
    fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor libcap systemd
  ];
  atomLib = lib.makeLibraryPath atomPkgs;
  atomLib64 = lib.makeSearchPathOutputs "lib64" ["lib"] atomPkgs;

in stdenv.mkDerivation rec {
  name = "atom-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
    sha256 = "1kl2pc0smacn4lgk5wwlaiw03rm8b0763vaisgp843p35zzsbc9n";
    name = "${name}.deb";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    ar p $src data.tar.gz | tar -C $out -xz ./usr
    substituteInPlace $out/usr/share/applications/atom.desktop \
      --replace /usr/share/atom $out/bin
    mv $out/usr/* $out/
    rm -r $out/share/lintian
    rm -r $out/usr/
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/atom/atom
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/atom/resources/app/apm/bin/node
    wrapProgram $out/bin/atom \
      --prefix "LD_LIBRARY_PATH" : "${atomLib}:${atomLib64}" \
      --prefix "PATH" : "${gvfs}/bin"
    wrapProgram $out/bin/apm \
      --prefix "LD_LIBRARY_PATH" : "${atomLib}:${atomLib64}"
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = licenses.mit;
    maintainers = [ maintainers.offline maintainers.nequissimus ];
    platforms = [ "x86_64-linux" ];
  };
}
