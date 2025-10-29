{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coreshot";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KGaMCL9BCGZwK7HQz87B1qrNvx5SQyMooZw4MwMdCc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libcprime
    libcsys
  ];

  meta = {
    description = "Screen capture utility from the C Suite";
    mainProgram = "coreshot";
    homepage = "https://gitlab.com/cubocore/coreapps/coreshot";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
