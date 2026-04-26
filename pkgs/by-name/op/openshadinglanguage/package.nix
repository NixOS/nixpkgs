{
  bison,
  boost,
  cmake,
  fetchFromGitHub,
  flex,
  hexdump,
  lib,
  libxml2,
  llvmPackages,
  openexr,
  openimageio,
  partio,
  pugixml,
  python3Packages,
  robin-map,
  stdenv,
  zlib,
}:

let
  boost_static = boost.override { enableStatic = true; };
  inherit (llvmPackages) clang libclang llvm;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openshadinglanguage";
  version = "1.15.3.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenShadingLanguage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xNu973TbPIIOLpZDe2E9sRmX7GpidQeQrKkpz7zkuBY=";
  };

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RTTI" true)
    (lib.cmakeBool "USE_BOOST_WAVE" true)
    (lib.cmakeFeature "Boost_ROOT" "${boost}")

    # Build system implies llvm-config and llvm-as are in the same directory.
    # Override defaults.
    (lib.cmakeFeature "LLVM_BC_GENERATOR" "${clang}/bin/clang++")
    (lib.cmakeFeature "LLVM_CONFIG" "${llvm.dev}/bin/llvm-config")
    (lib.cmakeFeature "LLVM_DIRECTORY" "${llvm}")
  ];

  prePatch = ''
    substituteInPlace src/cmake/modules/FindLLVM.cmake \
      --replace-fail "NO_DEFAULT_PATH" ""
  '';

  preConfigure = ''
    patchShebangs src/liboslexec/serialize-bc.bash
  '';

  nativeBuildInputs = [
    bison
    clang
    cmake
    flex
  ];

  buildInputs = [
    boost_static
    hexdump
    libclang
    llvm
    openexr
    openimageio
    partio
    pugixml
    python3Packages.pybind11
    robin-map
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libxml2
  ];

  propagatedBuildInputs = [
    python3Packages.openimageio
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/*.pc \
      --replace '=''${exec_prefix}//' '=/'
  '';

  meta = {
    description = "Advanced shading language for production GI renderers";
    homepage = "http://openshadinglanguage.org";
    maintainers = [ lib.maintainers.amarshall ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
