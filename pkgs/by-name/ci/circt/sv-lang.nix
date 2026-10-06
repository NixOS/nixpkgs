# CIRCT depends on a specific sv-lang revision, so pin it separately from nixpkgs' sv-lang.
{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  catch2_3,
  cmake,
  ninja,
  fmt,
  llvmPackages,
  mimalloc,
  python3,
  tomlplusplus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "circt-sv-lang";
  version = "11.0";

  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    rev = "44dc55f99b9c64971893013e7931e643fbedcf23";
    hash = "sha256-tKse5rV5kHZmCOb8Zb8k4bOw4wN3pDfY5exdpva57bU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Needed for the wrapped clang-scan-deps to find the C++20 module headers.
    llvmPackages.clang-tools
  ];

  buildInputs = [
    boost
    catch2_3
    fmt
    mimalloc
  ];

  propagatedBuildInputs = [
    tomlplusplus
  ];

  cmakeFlags = [
    # Keep installation paths compatible with the CIRCT build.
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "SLANG_INCLUDE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "SLANG_USE_SYSTEM_TOMLPLUSPLUS" true)
  ];

  doCheck = true;

  meta = {
    description = "SystemVerilog compiler and language services pinned for CIRCT";
    homepage = "https://github.com/MikePopoloski/slang";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
