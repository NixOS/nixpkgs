{
  llvmPackages,
  lib,
  fetchFromGitHub,
  cmake,
  python3,
  curl,
  libxml2,
  libffi,
  xar,
  versionCheckHook,
  rev ? "unknown",
  debug ? false,
  checks ? true,
}:
let
  inherit (lib.strings) optionalString;
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {

  pname = "c3c${optionalString debug "-debug"}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "c3lang";
    repo = "c3c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MOnYWlGcxLX+agChuk0BPq8BWsVvNP2QYqaGk24lb5Q=";
  };

  cmakeBuildType = if debug then "Debug" else "Release";

  postPatch = ''
    substituteInPlace git_hash.cmake \
      --replace-fail "\''${GIT_HASH}" "${rev}"
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Werror" ""
  '';

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DC3_ENABLE_CLANGD_LSP=${if debug then "ON" else "OFF"}"
    "-DC3_LLD_DIR=${llvmPackages.lld.lib}/lib"
    "-DLLVM_CRT_LIBRARY_DIR=${llvmPackages.compiler-rt}/lib/darwin"
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    llvmPackages.compiler-rt
    curl
    libxml2
    libffi
  ] ++ lib.optionals llvmPackages.stdenv.hostPlatform.isDarwin [ xar ];

  nativeCheckInputs = [ python3 ];

  doCheck =
    lib.elem llvmPackages.stdenv.system [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ]
    && checks;

  checkPhase = ''
    runHook preCheck
    ( cd ../resources/testproject; ../../build/c3c build --trust=full )
    ( cd ../test; ../build/c3c compile-run -O1 src/test_suite_runner.c3 -- ../build/c3c test_suite )
    runHook postCheck
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
