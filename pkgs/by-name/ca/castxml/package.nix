{
  cmake,
  fetchFromGitHub,
  lib,
  libffi,
  libxml2,
  llvmPackages,
  python3,
  stdenv,
  testers,
  zlib,
  # Boolean flags
  withHTML ? true,
  withManual ? true,
}:

let
  inherit (llvmPackages) libclang llvm;
  inherit (python3.pkgs) sphinx;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "castxml";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "CastXML";
    repo = "CastXML";
    rev = "v${finalAttrs.version}";
    hash = "sha256-icTos9HboZXvojQPX+pRkpBYiZ5SXSMb9XtvRnXNHuo=";
  };

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals (withManual || withHTML) [
      sphinx
    ];

  buildInputs =
    [
      libffi
      libxml2
      llvm
      zlib
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      libclang
    ];

  cmakeFlags =
    [
      (lib.cmakeOptionType "path" "CLANG_RESOURCE_DIR"
        "${lib.getLib libclang}/lib/clang/${lib.versions.major libclang.version}"
      )

      (lib.cmakeBool "SPHINX_HTML" withHTML)
      (lib.cmakeBool "SPHINX_MAN" withManual)
    ]
    ++ lib.optionals stdenv.isDarwin [
      (lib.cmakeOptionType "path" "Clang_DIR" "${lib.getDev libclang}/lib/cmake/clang")
    ];

  doCheck = true;

  strictDeps = true;

  passthru.tests = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/CastXML/CastXML";
    description = "C-family Abstract Syntax Tree XML Output";
    license = lib.licenses.asl20;
    mainProgram = "castxml";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
