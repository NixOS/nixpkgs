{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  libsForQt5,
  libGLU,
  lib3ds,
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
  tbb,
  embree,
  libigl,
  corto,
  openctm,
  structuresynth,
}:

let
  tinygltf-src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    tag = "v2.6.3";
    hash = "sha256-IyezvHzgLRyc3z8HdNsQMqDEhP+Ytw0stFNak3C8lTo=";
  };

  # requires submodules to build
  lib3mf-src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = "lib3mf";
    tag = "v2.3.2";
    fetchSubmodules = true;
    hash = "sha256-pKjnN9H6/A2zPvzpFed65J+mnNwG/dkSE2/pW7IlN58=";
  };
in
stdenv.mkDerivation {
  pname = "meshlab-unstable";
  version = "2023.12-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    # note that this is in branch devel
    rev = "72142583980b6dbfc5b85c6cca226a72f48497a9";
    hash = "sha256-ev6b8sgJsjvD8KMBbC6kbrVvTxTxpqsXu/sK1Ih6+OA=";
    # needed for an updated version of vcg in their submodule
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/meshlab/CMakeLists.txt \
      --replace-fail "set_additional_settings_info_plist(" "# set_additional_settings_info_plist(" \
      --replace-fail "	TARGET meshlab" "#	TARGET meshlab" \
      --replace-fail "	FILE \''${MESHLAB_BUILD_DISTRIB_DIR}/meshlab.app/Contents/Info.plist)" \
                     "#	FILE \''${MESHLAB_BUILD_DISTRIB_DIR}/meshlab.app/Contents/Info.plist)"
  '';

  buildInputs = [
    libGLU
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qtxmlpatterns
    lib3ds
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
    tbb
    embree
    libigl
    corto
    openctm
    structuresynth
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  preConfigure = ''
    mkdir src/external/downloads
    cp -r --no-preserve=mode,ownership ${lib3mf-src} src/external/downloads/lib3mf-2.3.2

    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
    substituteInPlace src/external/tinygltf.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/tinygltf-2.6.3 ${tinygltf-src}
    substituteInPlace src/external/libigl.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/libigl-'$'{LIBIGL_VER} ${libigl}
    substituteInPlace src/external/nexus.cmake \
      --replace-fail '$'{NEXUS_DIR}/src/corto ${corto.src}
    substituteInPlace src/external/levmar.cmake \
      --replace-fail '$'{LEVMAR_LINK} ${levmar.src} \
      --replace-warn "MD5 ''${LEVMAR_MD5}" ""
    substituteInPlace src/external/ssynth.cmake \
      --replace-fail '$'{SSYNTH_LINK} ${structuresynth.src} \
      --replace-warn "MD5 ''${SSYNTH_MD5}" ""
    substituteInPlace src/common_gui/CMakeLists.txt \
      --replace-warn "MESHLAB_LIB_INSTALL_DIR" "CMAKE_INSTALL_LIBDIR"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin,lib}
    mv $out/meshlab.app $out/Applications/
    ln $out/Applications/meshlab.app/Contents/Frameworks/* $out/lib/
    makeWrapper $out/{Applications/meshlab.app/Contents/MacOS,bin}/meshlab
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
      patchelf --add-needed $out/lib/meshlab/lib3mf.so $out/lib/meshlab/plugins/libio_3mf.so
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapQtApp "$out/Applications/meshlab.app/Contents/MacOS/meshlab"
      install_name_tool -change libopenctm.dylib "${lib.getOutput "out" openctm}/lib/libopenctm.dylib" \
        "$out/Applications/meshlab.app/Contents/PlugIns/libio_ctm.so"
    '';

  # The hook will wrap all the plugin binaries, make they are not a
  # valid plugin. So we have to wrap the main app manually.
  # See: https://github.com/NixOS/nixpkgs/pull/396295#issuecomment-3137779781
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = {
    description = "System for processing and editing 3D triangular meshes (unstable)";
    mainProgram = "meshlab";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pca006132 ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
