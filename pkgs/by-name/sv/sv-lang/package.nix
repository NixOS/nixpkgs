{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  catch2_3,
  cmake,
  ninja,
  fmt,
  mimalloc,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sv-lang";
  version = "11.0";

  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-popHzwX0qwv2POAl7/qX3e//OwJRXGtSl9xogpSn2LI=";
  };

  cmakeFlags = [
    # fix for https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"

    "-DSLANG_INCLUDE_PYLIB=ON"
    "-DSLANG_INCLUDE_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    (python3.withPackages (pyPkgs: with pyPkgs; [ pybind11 ]))
    ninja
  ];

  strictDeps = true;

  buildInputs = [
    boost
    fmt
    mimalloc
    # though only used in tests, cmake will complain its absence when configuring
    catch2_3
  ];

  # TODO: a mysterious linker error occurs when building the unittests on darwin.
  # The error occurs when using catch2_3 in nixpkgs, not when fetching catch2_3 using CMake
  doCheck = !stdenv.hostPlatform.isDarwin;

  # Pass through the python version for which the pylib (python extension
  # module) was built for.
  passthru.pythonVersion = python3.pythonVersion;

  meta = {
    description = "SystemVerilog compiler and language services";
    homepage = "https://github.com/MikePopoloski/slang";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sharzy ];
    mainProgram = "slang";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
