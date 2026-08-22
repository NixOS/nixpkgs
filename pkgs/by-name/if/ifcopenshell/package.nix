{
  lib,
  stdenv,
  testers,
  # fetchers
  fetchFromGitHub,
  gitUpdater,
  # build tools
  autoPatchelfHook,
  cmake,
  swig,
  # native dependencies
  boost,
  cgal_5,
  eigen,
  gmp,
  hdf5,
  icu,
  libaec,
  libxml2,
  mpfr,
  nlohmann_json,
  opencascade-occt,
  proj,
  sqlite,
  zlib,
  withPython ? false,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ifcopenshell";
  version = "0.8.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    # NOTE: every part of the ifcopenshell source trees lives their life independently from each other
    # The bin utilities uses `ifcconvert-*` releases
    # but the python bindings points on a specific ifcopenshell commits (wich is *not* necessarily a tag)
    # same thing for the blender extensions etc...
    # Be careful when using this derivation to build other tools from ifcopenshell org ;-)
    tag = "ifcconvert-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-QL+b46tOqoaN8XhxM02B2LWeAdu4OhhbCCVe7bMohBI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    # c++
    cmake
    swig
  ]
  ++ lib.optionals withPython [ python3 ];

  buildInputs = [
    # ifcopenshell needs stdc++
    (lib.getLib stdenv.cc.cc)
    boost
    cgal_5
    eigen
    gmp
    hdf5
    icu
    libaec
    libxml2
    mpfr
    nlohmann_json
    opencascade-occt
    proj
    sqlite
  ];

  patches = [
    ./boost_components_system.patch
  ];

  # we need to explicitly install python bindings
  postBuild = lib.optional withPython ''
    echo "current dir $(pwd)"
    ls -al .
    ls -al ../
    mkdir -p $lib/${python3.sitePackages}/ifcwrap
    install -m 0755 ./ifcwrap/_ifcopenshell_wrapper.cpython-${
      lib.versions.major python3.version + lib.versions.minor python3.version
    }-${stdenv.targetPlatform.system}-gnu.so $lib/${python3.sitePackages}/ifcwrap
    install -m 0755 ./ifcwrap/ifcopenshell_wrapper.py $lib/${python3.sitePackages}/ifcwrap
  '';

  # for some reason, when building ifcwrap, the RPATH is an absolute path to the build folder
  # we need to patch that because nix-build refuses to continue otherwise
  # autopatchelfhook doesn't work because it is executed later in the build process
  preFixup = lib.optional withPython ''
    patchelf --shrink-rpath --allowed-rpath-prefixes /nix/store $lib/${python3.sitePackages}/ifcwrap/_ifcopenshell_wrapper.cpython-${
      lib.versions.major python3.version + lib.versions.minor python3.version
    }-${stdenv.targetPlatform.system}-gnu.so
  '';

  # We still build with python to generate ifcopenshell_wrapper.py and ifcopenshell_wrapper.so
  cmakeFlags = [
    "-DVERSION_OVERRIDE=ON" # I really don't know why it's not the default...
    "-DENABLE_BUILD_OPTIMIZATIONS=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_IFCGEOM=ON"
    # TODO for man pages ?
    # option(BUILD_DOCUMENTATION "Build IfcOpenShell Documentation." OFF)
    "-DBUILD_EXAMPLES=OFF"
    # TODO add qt6
    # "-DBUILD_QTVIEWER=ON"
    "-DGLTF_SUPPORT=ON"
    "-DCOLLADA_SUPPORT=OFF"
    "-DWITH_PROJ=ON"
    "-DEIGEN_DIR=${eigen}/include/eigen3"
    "-DJSON_INCLUDE_DIR=${nlohmann_json}/include/"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${lib.getLib opencascade-occt}/lib"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DHDF5_SUPPORT=ON"
    "-DHDF5_INCLUDE_DIR=${hdf5.dev}/include/"
    "-DHDF5_LIBRARIES=${lib.getLib hdf5}/lib/libhdf5_cpp.so;${lib.getLib hdf5}/lib/libhdf5.so;${lib.getLib zlib}/lib/libz.so;${lib.getLib libaec}/lib/libaec.so;"
  ]
  # BUILD_IFCPYTHON=ON is the default
  ++ lib.optional (!withPython) "-DBUILD_IFCPYTHON=OFF"
  ++ lib.optionals withPython [
    "-DPYTHON_MODULE_INSTALL_DIR=${python3.sitePackages}/ifcopenshell"
  ];

  preConfigure = ''
    cd cmake
  '';

  outputs = [
    "out"
    "dev"
    "lib"
  ];
  passthru = {
    updateScript = gitUpdater { rev-prefix = "ifcconvert-"; };
    # We'd love to do that, but unfortunately, IfcConvert still reports 0.8.0 even in 0.8.4.
    # see https://github.com/IfcOpenShell/IfcOpenShell/issues/8164
    # tests = {
    #   version = testers.testVersion {
    #     command = "IfcConvert --version";
    #     package = finalAttrs.finalPackage;
    #   };
    # };
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "IfcConvert";
    description = "Open source IFC library and geometry engine";
    homepage = "https://ifcopenshell.org/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ autra ];
  };
})
