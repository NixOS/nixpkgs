{
  lib,
  stdenv,
  fetchFromGitLab,
  libzen,
  libmediainfo,
  zlib,
  qt6,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coreinfo";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/L69lrkJZh+SJRoNxvogdJ5KRIorwcBzm7WGxrNpexM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libzen
    libmediainfo
    zlib
    libcprime
    libcsys
  ];

  meta = {
    description = "File information tool from the C Suite";
    mainProgram = "coreinfo";
    homepage = "https://gitlab.com/cubocore/coreapps/coreinfo";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
