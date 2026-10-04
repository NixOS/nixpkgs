{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  makeWrapper,
  binutils,
  gcc,
  llvmPackages,
  pkgsCross,
  runCommand,
  stdenv,
  testers,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "rakec";
  version = "0.7.0";
  dunePackages = [ "rake" ];
  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "rakelang";
    repo = "rake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gxw4vlbFjdsqDu//jyou6gOmyaesWH2FNoDfP4000ZU=";
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
  postCheck = ''
    dune build -p rake -j "$NIX_BUILD_CORES" @runtest-native @runtest-wasm
  '';

  postFixup = ''
    wrapProgram $out/bin/rakec \
      --prefix PATH : ${
        lib.makeBinPath [
          binutils
          gcc
          pkgsCross.aarch64-multiplatform.buildPackages.binutils
          pkgsCross.aarch64-multiplatform.stdenv.cc
          llvmPackages.clang-unwrapped
          llvmPackages.llvm
          llvmPackages.lld
        ]
      } \
      --set-default RAKE_WASM_CFLAGS "-isystem ${pkgsCross.wasi32.wasilibc.dev}/include"
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    backends =
      runCommand "rakec-installed-backends-${finalAttrs.version}"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          rakec --verify-native --target wasm-simd128 -o wasm.o ${finalAttrs.src}/demo/safe-root/safe_root.rk
          rakec --verify-native --target aarch64-neon -o neon.o ${finalAttrs.src}/demo/safe-root/safe_root.rk
          ${lib.optionalString stdenv.hostPlatform.isx86_64 ''
            for target in x86-sse2 x86-avx2 x86-avx512; do
              rakec --verify-native --target "$target" -o "$target.o" ${finalAttrs.src}/demo/safe-root/safe_root.rk
            done
          ''}
          touch "$out"
        '';
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
