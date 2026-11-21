{
  lib,
  stdenv,
  fetchFromGitLab,
  desktop-file-utils,
  desktopToDarwinBundle,
  shared-mime-info,
  ninja,
  pkg-config,
  libiconv,
  libx11,
  libxcursor,
  libxext,
  libxi,
  freetype,
  fontconfig,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "azpainter";
  version = "3.0.13";

  src = fetchFromGitLab {
    owner = "azelpg";
    repo = "azpainter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EDef26ssyqcP/NSrt1zQZWOO2qsXjPxBgf5Dti2veXQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    shared-mime-info # for update-mime-info
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libx11
    libxcursor
    libxext
    libxi
    freetype
    fontconfig
    libjpeg
    libpng
    libtiff
    libwebp
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  preBuild = ''
    cd build
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Full color painting software for illustration drawing";
    homepage = "https://azelpg.gitlab.io/azsky2/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "azpainter";
  };
})
