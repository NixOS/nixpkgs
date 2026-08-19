{
  binaryen,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  lld,
  nodejs,
  npmHooks,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "extism-js-core";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "js-pdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U2C82By8JXUrtaAceZ5xr5Fb9Ltipyvd/sXG+Dsi8F8=";
  };

  cargoHash = "sha256-BBhHTzG0FU4AOuUz7yjp4bpELr1vEVdwT+vyyuITagE=";

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
      --replace-fail '1.6.1' '${finalAttrs.version}'
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

  env.RUSTFLAGS = "-C linker=wasm-ld";

  # stdenv handles setting up the appropriate env variables
  env.RQUICKJS_SYS_NO_WASI_SDK = 1;

  cargoBuildFlags = [ "--package=js-pdk-core" ];

  __structuredAttrs = true;

  meta = {
    # Fails to build on darwin due to libiconv linking failure (ld: library not found for -liconv)
    # See https://github.com/NixOS/nixpkgs/pull/523442 for a (failed) attempt at fixing the issue
    broken = stdenv.buildPlatform.isDarwin;
    changelog = "https://github.com/extism/js-pdk/releases/tag/${finalAttrs.src.tag}";
    description = "Write Extism plugins in JavaScript & TypeScript (WASM core)";
    homepage = "https://github.com/extism/js-pdk";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.diogotcorreia
      lib.maintainers.dotlambda
    ];
    platforms = [
      "wasm32-wasip1"
    ];
  };
})
