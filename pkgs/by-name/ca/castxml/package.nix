{
  lib,
  cmake,
  fetchFromGitHub,
  libffi,
  libxml2,
  llvmPackages,
  sphinx,
  stdenv,
  testers,
  zlib,
  # Boolean flags
  withHTML ? true,
  withManual ? true,
}:

let
  inherit (llvmPackages) libclang llvm;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "castxml";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "CastXML";
    repo = "CastXML";
    rev = "v${finalAttrs.version}";
    hash = "sha256-81I+Uh2HrEenp9iAW+TO+MUyXhXRMVDI+BZuVA4C/pE=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals (withManual || withHTML) [ sphinx ];

  buildInputs = [
    libclang
    libffi
    libxml2
    llvm
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeOptionType "path" "CLANG_RESOURCE_DIR"
      "${lib.getLib libclang}/lib/clang/${lib.versions.major libclang.version}"
    )

    (lib.cmakeBool "SPHINX_HTML" withHTML)
    (lib.cmakeBool "SPHINX_MAN" withManual)
  ];

  doCheck = true;

  strictDeps = true;

  # darwin clang adds `-isysroot` when $SDKROOT is set. this confuses the
  # regular expressions for the disabled tests below.
  checkPhase = ''
    runHook preCheck
    ctest -E 'cmd.cc-gnu-(src-cxx|c-src-c)-cmd' -j $NIX_BUILD_CORES
    runHook postCheck
  '';

  passthru.tests = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/CastXML/CastXML";
    description = "C-family Abstract Syntax Tree XML Output";
    license = lib.licenses.asl20;
    mainProgram = "castxml";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
