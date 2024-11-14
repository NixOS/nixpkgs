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
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "c3c";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "c3lang";
    repo = "c3c";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2OxUHnmFtT/TunfO+fOBOrkaHKlnqpO1wJWs79wkvAY=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${LLVM_LIBRARY_DIRS}" "${llvmPackages.lld.lib}/lib ${llvmPackages.llvm.lib}/lib"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    curl
    libxml2
    libffi
  ] ++ lib.optionals llvmPackages.stdenv.hostPlatform.isDarwin [ xar ];

  nativeCheckInputs = [ python3 ];

  doCheck = llvmPackages.stdenv.system == "x86_64-linux";

  checkPhase = ''
    runHook preCheck
    ( cd ../resources/testproject; ../../build/c3c build )
    ( cd ../test; python src/tester.py ../build/c3c test_suite )
    runHook postCheck
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Compiler for the C3 language";
    homepage = "https://github.com/c3lang/c3c";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      anas
    ];
    platforms = platforms.all;
    mainProgram = "c3c";
  };
})
