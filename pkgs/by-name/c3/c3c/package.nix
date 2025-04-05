{
  lib,
  fetchFromGitHub,
  llvmPackages,
  cmake,
  python3,
  curl,
  libxml2,
  libffi,
  xar,
  rev ? "unknown",
  debug ? false,
  checks ? false,
}:
let
  inherit (lib.strings) optionalString;
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {

  pname = "c3c${optionalString debug "-debug"}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "c3lang";
    repo = "c3c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SCUMyc8Gf7TAOXRppooNiyfbM84CUoIvokgvNgODqw8=";
  };

  cmakeBuildType = if debug then "Debug" else "Release";

  postPatch = ''
    substituteInPlace git_hash.cmake \
      --replace-fail "\''${GIT_HASH}" "${rev}"
  '';

  cmakeFlags = [
    "-DC3_ENABLE_CLANGD_LSP=${if debug then "ON" else "OFF"}"
    "-DC3_LLD_DIR=${llvmPackages.lld.lib}/lib"
    "-DLLVM_CRT_LIBRARY_DIR=${llvmPackages.compiler-rt}/lib/darwin"
  ];

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm
    llvmPackages.lld
    llvmPackages.compiler-rt
  ];

  buildInputs = [
    curl
    libxml2
    libffi
  ] ++ lib.optionals llvmPackages.stdenv.hostPlatform.isDarwin [ xar ];

  nativeCheckInputs = [ python3 ];

  doCheck = llvmPackages.stdenv.system == "x86_64-linux" && checks;

  checkPhase = ''
    runHook preCheck
    ( cd ../resources/testproject; ../../build/c3c build --trust=full )
    ( cd ../test; ../build/c3c compile-run -O1 src/test_suite_runner.c3 -- ../build/c3c test_suite )
    runHook postCheck
  '';

  meta = with lib; {
    description = "Compiler for the C3 language";
    homepage = "https://github.com/c3lang/c3c";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      hucancode
      anas
    ];
    platforms = platforms.all;
    mainProgram = "c3c";
  };
})
