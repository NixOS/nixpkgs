{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  catch2_3,
  cmake,
  ninja,
  fmt,
  llvmPackages,
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

  patches = [
    (fetchpatch {
      name = "fmt-12.2.patch";
      url = "https://github.com/MikePopoloski/slang/commit/5a898b4b9225d281902fcd59fe4732b1561677d2.patch";
      excludes = [ "tests/unittests/diagnostics/WaiverTests.cpp" ];
      hash = "sha256-Y+GG8UINWXh7eTXEweM42oPY8ByP4DQYgTjSLukz4I4=";
    })
  ];

  patchFlags = [
    "-p1"
    "-F3"
  ];

  cmakeFlags = [
    # fix for https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"

    "-DSLANG_INCLUDE_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    python3
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # needs the wrapped clang-scan-deps to find the C++20 module headers
    llvmPackages.clang-tools
  ];

  strictDeps = true;

  buildInputs = [
    boost
    fmt
    mimalloc
    # though only used in tests, cmake will complain its absence when configuring
    catch2_3
  ];

  doCheck = true;

  meta = {
    description = "SystemVerilog compiler and language services";
    homepage = "https://github.com/MikePopoloski/slang";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sharzy
      carlossless
    ];
    mainProgram = "slang";
    platforms = lib.platforms.all;
  };
})
