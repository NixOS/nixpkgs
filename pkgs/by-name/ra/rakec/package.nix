{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  makeWrapper,
  binutils,
  llvmPackages,
  pkgsCross,
  testers,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "rakec";
  version = "0.6.0-beta";
  dunePackages = [ "rake" ];
  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "rakelang";
    repo = "rake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UrQbA9T1y0J/4G/J9dm3/OdlSDOa22xHsxiz0c9e6oM=";
  };

  nativeBuildInputs = [
    ocamlPackages.menhir
    ocamlPackages.js_of_ocaml-compiler
    makeWrapper
  ];
  buildInputs = with ocamlPackages; [
    ppx_deriving
    js_of_ocaml
    js_of_ocaml-ppx
    cmdliner
  ];

  doCheck = true;
  nativeCheckInputs = [
    binutils
    pkgsCross.aarch64-multiplatform.buildPackages.binutils
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
  ];
  preBuild = ''
    export XDG_CACHE_HOME="$TMPDIR/dune-cache"
  '';

  postFixup = ''
    wrapProgram $out/bin/rakec \
      --prefix PATH : ${
        lib.makeBinPath [
          binutils
          pkgsCross.aarch64-multiplatform.buildPackages.binutils
          llvmPackages.clang-unwrapped
          llvmPackages.llvm
          llvmPackages.lld
        ]
      }
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Vector-first programming language for predictable SIMD";
    homepage = "https://rake-lang.org";
    changelog = "https://github.com/rakelang/rake/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
    mainProgram = "rakec";
    platforms = lib.platforms.linux;
  };
})
