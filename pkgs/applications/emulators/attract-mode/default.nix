{
  expat,
  fetchFromGitHub,
  ffmpeg_4,
  fontconfig,
  freetype,
  libarchive,
  libjpeg,
  libGLU,
  libGL,
  openal,
  pkg-config,
  sfml,
  lib,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "attract-mode";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "mickelson";
    repo = "attract";
    rev = "v${version}";
    sha256 = "sha256-gKxUU2y6Gtm5a/tXYw/fsaTBrriNh5vouPGICs3Ph3c=";
  };

  nativeBuildInputs = [ pkg-config ];

  patchPhase = ''
    sed -i "s|prefix=/usr/local|prefix=$out|" Makefile
  '';

  buildInputs = [
    expat
    ffmpeg_4
    fontconfig
    freetype
    libarchive
    libjpeg
    libGLU
    libGL
    openal
    sfml
    zlib
  ];

  meta = with lib; {
    description = "A frontend for arcade cabinets and media PCs";
    homepage = "http://attractmode.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = with platforms; linux;
    mainProgram = "attract";
  };
}
