{ stdenv, fetchurl, coreutils , unzip, which, pkgconfig , dbus
, freetype, xdg_utils , libXext, glib, pango , cairo, libX11
, libxdg_basedir , libXScrnSaver, xproto, libXinerama , perl
}:

stdenv.mkDerivation rec {
  name = "dunst-0.5.0";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/knopwob/dunst/archive/v0.5.0.zip";
    sha256 = "08myzhpb1afffcfk3mpmc7gs9305x853b0553fxf3lkgksmg70a6";
  };

  buildInputs =
  [ coreutils unzip which pkgconfig dbus freetype
    xdg_utils libXext glib pango cairo libX11 libxdg_basedir
    libXScrnSaver xproto libXinerama perl];

  buildPhase = ''
    export VERSION=${version};
    export PREFIX=$out;
    make dunst;
  '';

  meta = {
    description = "lightweight and customizable notification daemon";
    homepage = http://www.knopwob.org/dunst/;
    license = stdenv.lib.licenses.bsd3;
  };
}
