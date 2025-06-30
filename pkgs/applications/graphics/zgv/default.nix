{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  SDL,
  SDL_image,
  libjpeg,
  libpng,
  libtiff,
}:

stdenv.mkDerivation rec {
  pname = "zgv";
  version = "5.9";
  src = fetchurl {
    url = "https://www.svgalib.org/rus/zgv/${pname}-${version}.tar.gz";
    sha256 = "1fk4i9x0cpnpn3llam0zy2pkmhlr2hy3iaxhxg07v9sizd4dircj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL
    SDL_image
    libjpeg
    libpng
    libtiff
  ];

  hardeningDisable = [ "format" ];

  makeFlags = [
    "BACKEND=SDL"
  ];

  patches = [
    ./add-include.patch
    (fetchpatch {
      url = "https://foss.aueb.gr/mirrors/linux/gentoo/media-gfx/zgv/files/zgv-5.9-libpng15.patch";
      sha256 = "1blw9n04c28bnwcmcn64si4f5zpg42s8yn345js88fyzi9zm19xw";
    })
    ./switch.patch
  ];

  patchFlags = [ "-p0" ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/zgv $out/bin
  '';

  meta = with lib; {
    homepage = "http://www.svgalib.org/rus/zgv/";
    description = "Picture viewer with a thumbnail-based selector";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "zgv";
  };
}
