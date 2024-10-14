{
  lib,
  cmake,
  fetchFromGitHub,
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
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "CastXML";
    repo = "CastXML";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J4Z/NjCVOq4QS7ncCi87P5YPgqRwFyDAc14uS5T7s6M=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals (withManual || withHTML) [ sphinx ];

  buildInputs = [
    libclang
    libffi
    libxml2
    llvm
    zlib
  ];

  cmakeFlags =
    [
      (lib.cmakeOptionType "path" "CLANG_RESOURCE_DIR"
        "${lib.getLib libclang}/lib/clang/${lib.versions.major libclang.version}"
      )

      (lib.cmakeBool "SPHINX_HTML" withHTML)
      (lib.cmakeBool "SPHINX_MAN" withManual)
    ];

  doCheck = true;

  strictDeps = true;

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
