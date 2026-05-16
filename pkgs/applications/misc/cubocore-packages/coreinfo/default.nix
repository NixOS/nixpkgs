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
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ct/vAxtdFcXIxleaePhWD5L42d88go/3arYKSrw/c2c=";
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
