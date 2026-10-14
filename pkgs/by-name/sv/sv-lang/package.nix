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
  pname = "sv-lang";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s52DzaOdVdXLahJ5fn92V5VhTgzdd3xYuIlWByq58+0=";
  };

  cmakeFlags = [
    # fix for https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"

    (lib.cmakeBool "SLANG_USE_SYSTEM_FMT" true)
    (lib.cmakeBool "SLANG_USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "SLANG_USE_SYSTEM_TOMLPLUSPLUS" true)

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
    tomlplusplus
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
