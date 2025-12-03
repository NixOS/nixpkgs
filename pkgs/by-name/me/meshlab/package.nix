{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  libsForQt5,
  libGLU,
  lib3ds,
  lib3mf,
  bzip2,
  muparser,
  eigen,
  glew,
  gmp,
  levmar,
  qhull,
  cmake,
  cgal,
  boost,
  mpfr,
  xercesc,
  onetbb,
  embree,
  vcg,
  libigl,
  corto,
  openctm,
  structuresynth,
  vclab-nexus,
}:

let
  downloads = [
    "DLL_EMBREE"
    "SOURCE_BOOST"
    "SOURCE_CGAL"
    "SOURCE_EMBREE"
    "SOURCE_LEVMAR"
    "SOURCE_LIB3DS"
    "SOURCE_LIBE57"
    "SOURCE_LIBIGL"
    "SOURCE_MUPARSER"
    "SOURCE_NEXUS"
    "SOURCE_OPENCTM"
    "SOURCE_QHULL"
    "SOURCE_STRUCTURE_SYNTH"
    "SOURCE_TINYGLTF"
    "SOURCE_U3D"
    "SOURCE_XERCE"
  ];
  cmakeFlagsDisallowDownload = lib.map (x: "-DMESHLAB_ALLOW_DOWNLOAD_${x}=OFF") downloads;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshlab";
  version = "2025.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    tag = "MeshLab-${finalAttrs.version}";
    hash = "sha256-6BozYzPCbBZ+btL4FCdzKlwKqTsvFWDfOXizzJSYo9s=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libGLU
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qtxmlpatterns
    lib3ds
    lib3mf
    bzip2
    muparser
    eigen
    glew
    gmp
    levmar
    qhull
    cgal
    boost
    mpfr
    xercesc
    onetbb
    embree
    vcg
    libigl
    corto
    openctm
    structuresynth
    vclab-nexus
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  patches = [
    # CMake: use system dependencies, install exports
    # ref. https://github.com/cnr-isti-vclab/meshlab/pull/1617
    # merged upstream
    ./1617_cmake-use-system-dependencies-install-exports.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./no-plist.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
  '';

  cmakeFlags = cmakeFlagsDisallowDownload;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin,lib}
    mv $out/meshlab.app $out/Applications/
    ln $out/Applications/meshlab.app/Contents/Frameworks/libmeshlab-common{,-gui}.dylib $out/lib/
    makeWrapper $out/{Applications/meshlab.app/Contents/MacOS,bin}/meshlab
    substituteInPlace $out/lib/cmake/meshlab/meshlabTargets-release.cmake --replace-fail \
      "{_IMPORT_PREFIX}/meshlab.app" \
      "{_IMPORT_PREFIX}/Applications/meshlab.app"
  '';

  # The hook will wrap all the plugin binaries, make they are not a
  # valid plugin. So we have to wrap the main app manually.
  # See: https://github.com/NixOS/nixpkgs/pull/396295#issuecomment-3137779781
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = lib.optional stdenv.hostPlatform.isLinux "--set QT_QPA_PLATFORM xcb";

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --add-needed $out/lib/meshlab/libmeshlab-common.so \
        --add-needed $out/lib/meshlab/libmeshlab-common-gui.so \
        $out/bin/.meshlab-wrapped
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapQtApp "$out/Applications/meshlab.app/Contents/MacOS/meshlab"
      install_name_tool -change libopenctm.dylib "${lib.getOutput "out" openctm}/lib/libopenctm.dylib" \
        "$out/Applications/meshlab.app/Contents/PlugIns/libio_ctm.so"
    '';

  meta = {
    description = "System for processing and editing 3D triangular meshes";
    mainProgram = "meshlab";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nim65s
      yzx9
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
