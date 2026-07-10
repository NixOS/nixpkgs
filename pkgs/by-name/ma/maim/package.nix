{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libpng,
  libjpeg,
  libwebp,
  libGLU,
  libGL,
  glm,
  libx11,
  libxext,
  libxfixes,
  libxrandr,
  libxcomposite,
  slop,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maim";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "maim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bbjV3+41cxAlKCEd1/nvnZ19GhctWOr5Lu4X+Vg3EAk=";
  };

  # TODO: drop -DCMAKE_POLICY_VERSION_MINIMUM once maim adds CMake 4 support
  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.10" ];
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
    libx11
    libxext
    libxfixes
    libxrandr
    libxcomposite
    slop
    icu
  ];

  doCheck = false;

  meta = {
    mainProgram = "maim";
    inherit (finalAttrs.src.meta) homepage;
    description = "Command-line screenshot utility";
    longDescription = ''
      maim (make image) takes screenshots of your desktop. It has options to
      take only a region, and relies on slop to query for regions. maim is
      supposed to be an improved scrot.
    '';
    changelog = "https://github.com/naelstrof/maim/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
