args: with args;
stdenv.mkDerivation rec {
  name = "luit-20060820";
  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "0cxf4agl7ky3ip01qi1vzmis8y1ddngbi2fi0q6bzv1jw458rlpi";
  };

  buildInputs = [libXt zlib pkgconfig libXfont libX11 libfontenc];

  configureFlags = "--with-locale-alias=${libX11}/share/X11/locale/locale.alias";
  meta = {
    description = "Luit is a filter that can be run between an arbitrary
      application and a UTF-8 terminal emulator.";
    homepage = http://invisible-island.net/luit;
  };
}
