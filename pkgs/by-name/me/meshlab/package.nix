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
  vcg,
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
  version = "2023.12";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    tag = "MeshLab-${finalAttrs.version}";
    hash = "sha256-AdUAWS741RQclYaSE3Tz1/I0YSinNAnfSaqef+Tib8Y=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    vcg # templated library
  ];

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

  postPatch = ''
    substituteInPlace src/external/tinygltf.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/tinygltf-2.6.3 ${tinygltf-src}
    substituteInPlace src/external/libigl.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/libigl-2.4.0 ${libigl}
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
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/meshlab/CMakeLists.txt \
      --replace-fail "set_additional_settings_info_plist(" "# set_additional_settings_info_plist(" \
      --replace-fail "	TARGET meshlab" "#	TARGET meshlab" \
      --replace-fail "	FILE \''${MESHLAB_BUILD_DISTRIB_DIR}/meshlab.app/Contents/Info.plist)" \
                     "#	FILE \''${MESHLAB_BUILD_DISTRIB_DIR}/meshlab.app/Contents/Info.plist)"
  '';

  cmakeFlags = [
    "-DVCGDIR=${vcg.src}"
  ]
  ++ cmakeFlagsDisallowDownload;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin,lib}
    mv $out/meshlab.app $out/Applications/
    ln $out/Applications/meshlab.app/Contents/Frameworks/libmeshlab-common.dylib $out/lib/
    makeWrapper $out/{Applications/meshlab.app/Contents/MacOS,bin}/meshlab
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
      patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
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
    maintainers = with lib.maintainers; [ yzx9 ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
