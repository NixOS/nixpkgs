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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sv-lang";
  version = "9.1";

  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IfRh6F6vA+nFa+diPKD2aMv9kRbvVIY80IqX0d+d5JA=";
  };

  postPatch = ''
    substituteInPlace external/CMakeLists.txt --replace-fail \
      'set(mimalloc_min_version "2.2")' \
      'set(mimalloc_min_version "${lib.versions.majorMinor mimalloc.version}")'
  ''
  # fmt 12 moved fmt::format out of fmt/core.h into fmt/format.h
  + ''
    substituteInPlace $(grep -rl '#include <fmt/core.h>' --include='*.cpp' --include='*.h' .) \
      --replace-fail '#include <fmt/core.h>' '#include <fmt/format.h>'
  '';

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
