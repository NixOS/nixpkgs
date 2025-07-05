{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  zlib,
  libpng,
  libjpeg,
  libwebp,
  libGLU,
  libGL,
  glm,
  libX11,
  libXext,
  libXfixes,
  libXrandr,
  libXcomposite,
  slop,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "maim";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "maim";
    rev = "v${version}";
    sha256 = "sha256-/tZqSJnKe8GiffSz9VIFKuxMktRld+hA4ZWP4TZQrlg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zlib
    libpng
    libjpeg
    libwebp
    libGLU
    libGL
    glm
    libX11
    libXext
    libXfixes
    libXrandr
    libXcomposite
    slop
    icu
  ];

  patches = [
    # Use C++17 as required by icu
    (fetchpatch {
      name = "maim-c++-17.patch";
      url = "https://github.com/naelstrof/maim/commit/e7fe09b6734baeb59081b8805be542c92178cf0f.patch";
      sha256 = "0z9zvrr8msfli88jmhxm5knysi385s48j2w7zpacc7qhf4c5zh8c";
    })
  ];

  doCheck = false;

  meta = {
    mainProgram = "maim";
    inherit (src.meta) homepage;
    description = "Command-line screenshot utility";
    longDescription = ''
      maim (make image) takes screenshots of your desktop. It has options to
      take only a region, and relies on slop to query for regions. maim is
      supposed to be an improved scrot.
    '';
    changelog = "https://github.com/naelstrof/maim/releases/tag/v${version}";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
