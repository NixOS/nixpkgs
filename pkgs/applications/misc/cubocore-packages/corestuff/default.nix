{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  xorg,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corestuff";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corestuff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/EI7oM7c7GKEQ+XQSiWwkJ7uNrJkxgLXEXZ6r5Jqh70=";
  };

  patches = [
    # Remove autostart
    ./0001-fix-installPhase.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.kglobalaccel
    xorg.libXcomposite
    libcprime
    libcsys
  ];

  meta = {
    description = "Activity viewer from the C Suite";
    mainProgram = "corestuff";
    homepage = "https://gitlab.com/cubocore/coreapps/corestuff";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    # Address boundary error
    broken = true;
  };
})
