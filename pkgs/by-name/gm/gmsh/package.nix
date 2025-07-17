{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  blas,
  lapack,
  gfortran,
  gmm,
  fltk,
  libjpeg,
  zlib,
  libGL,
  libGLU,
  xorg,
  opencascade-occt,
  llvmPackages,
  python3Packages,
  enablePython ? false,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "gmsh";
  version = "4.14.0";

  src = fetchurl {
    url = "https://gmsh.info/src/gmsh-${finalAttrs.version}-source.tgz";
    hash = "sha256-2019ogYumkNWqCCDITirmfl69jiL/rIVmaLq37C3aig=";
  };

  nativeBuildInputs =
    [
      cmake
      gfortran
    ]
    ++ lib.optional enablePython python3Packages.pythonImportsCheckHook
    ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

  buildInputs =
    [
      blas
      lapack
      gmm
      fltk
      libjpeg
      zlib
      opencascade-occt
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libGL
      libGLU
      xorg.libXrender
      xorg.libXcursor
      xorg.libXfixes
      xorg.libXext
      xorg.libXft
      xorg.libXinerama
      xorg.libX11
      xorg.libSM
      xorg.libICE
    ]
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  # N.B. the shared object is used by bindings
  cmakeFlags = [
    "-DENABLE_BUILD_SHARED=ON"
    "-DENABLE_BUILD_DYNAMIC=ON"
    "-DENABLE_OPENMP=ON"
  ];

  doCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "gmsh";
      exec = "gmsh";
      comment = finalAttrs.meta.description;
      desktopName = "Gmsh";
      genericName = "3D Mesh Generator";
      categories = [
        "Science"
        "Math"
      ];
      icon = "gmsh";
    })
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 ${./gmsh.svg} $out/share/icons/hicolor/scalable/apps/gmsh.svg
    ''
    + lib.optionalString enablePython ''
      mkdir -p $out/${python3Packages.python.sitePackages}
      mv $out/lib/gmsh.py $out/${python3Packages.python.sitePackages}
      mv $out/lib/*.dist-info $out/${python3Packages.python.sitePackages}
    '';

  pythonImportsCheck = [ "gmsh" ];

  meta = {
    description = "Three-dimensional finite element mesh generator";
    mainProgram = "gmsh";
    homepage = "https://gmsh.info/";
    changelog = "https://gitlab.onelab.info/gmsh/gmsh/-/releases/gmsh_${lib.concatStringsSep "_" (lib.versions.splitVersion finalAttrs.version)}#changelog";
    license = lib.licenses.gpl2Plus;
  };
})
