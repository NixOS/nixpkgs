{ lib, stdenv, fetchurl, pkg-config
, libX11, libXext, libXft, libXmu, libXinerama, libXrandr, libXpm
, imagemagick, libpng, libjpeg, libexif, libtiff, giflib, libwebp }:

stdenv.mkDerivation rec {
  pname = "windowmaker";
  version = "0.95.9";
  srcName = "WindowMaker-${version}";

  src = fetchurl {
    url = "http://windowmaker.org/pub/source/release/${srcName}.tar.gz";
    sha256 = "055pqvlkhipyjn7m6bb3fs4zz9rd1ynzl0mmwbhp05ihc3zmh8zj";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libX11 libXext libXft libXmu libXinerama libXrandr libXpm
                  imagemagick libpng libjpeg libexif libtiff giflib libwebp ];

  configureFlags = [
    "--with-x"
    "--enable-modelock"
    "--enable-randr"
    "--enable-webp"
    "--disable-magick" # Many distros reported imagemagick fails to be found
  ];

  meta = with lib; {
    homepage = "http://windowmaker.org/";
    description = "NeXTSTEP-like window manager";
    longDescription = ''
      Window Maker is an X11 window manager originally designed to
      provide integration support for the GNUstep Desktop
      Environment. In every way possible, it reproduces the elegant look
      and feel of the NEXTSTEP user interface. It is fast, feature rich,
      easy to configure, and easy to use. It is also free software, with
      contributions being made by programmers from around the world.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
