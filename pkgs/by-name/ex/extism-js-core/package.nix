{
  binaryen,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  lld,
  nodejs,
  npmHooks,
  runCommand,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "extism-js-core";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "js-pdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CLyH0gDtw988cTcw4B86/kejfbYWMXEVG9Y6PKAZazE=";
  };

  cargoHash = "sha256-9lFX+Q4318ClVIRT4/uCesyNYwU9H2vV+fD3553M2Dc=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-XrydnNXXhy/2sZXUGHuZvy+WF7dYIywrUAj8OHGlVRM=";
  };
  npmRoot = "crates/core/src/prelude";

  # https://github.com/extism/js-pdk/pull/154
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail '1.5.1' '${finalAttrs.version}'
  '';

  preBuild = ''
    pushd ${finalAttrs.npmRoot}
    npm run build
    popd
  '';

  # https://github.com/extism/js-pdk/blob/v1.6.0/Makefile#L25
  preFixup = ''
    wasm-opt --enable-reference-types --enable-bulk-memory --strip -O3 $out/bin/js_pdk_core.wasm -o $out/bin/js_pdk_core.wasm
  '';

  nativeBuildInputs = [
    binaryen
    lld
    nodejs
    npmHooks.npmConfigHook
    rustPlatform.bindgenHook
  ];

  # io-extras v0.18.4 uses #![feature]
  env.RUSTC_BOOTSTRAP = 1;

  env.RUSTFLAGS = "-C linker=wasm-ld";

  # rquickjs-sys expects the dir structure from wasi-sdk
  # https://github.com/DelSkayn/rquickjs/blob/v0.11.0/sys/build.rs#L216-L230
  # TODO: revisit when https://github.com/DelSkayn/rquickjs/pull/648 is released and extism updated
  env.WASI_SDK = runCommand "wasi-sdk" { } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe' stdenv.cc "wasm32-unknown-wasi-clang"} $out/bin/clang
    ln -s ${lib.getExe' stdenv.cc "wasm32-unknown-wasi-ar"} $out/bin/ar
    ln -s ${stdenv.cc}/nix-support $out/nix-support
    mkdir -p $out/share
    ln -s ${stdenv.cc.libc} $out/share/wasi-sysroot
  '';

  cargoBuildFlags = [ "--package=js-pdk-core" ];

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/extism/js-pdk/releases/tag/v${finalAttrs.version}";
    description = "Write Extism plugins in JavaScript & TypeScript (WASM core)";
    homepage = "https://github.com/extism/js-pdk";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.diogotcorreia
      lib.maintainers.dotlambda
    ];
    platforms = lib.platforms.wasi;
  };
})
