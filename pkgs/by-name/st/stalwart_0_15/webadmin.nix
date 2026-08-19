{
  lib,
  rustPlatform,
  stalwart_0_15,
  fetchFromGitHub,
  fetchpatch,
  trunk,
  tailwindcss_3,
  fetchNpmDeps,
  nix-update-script,
  nodejs,
  npmHooks,
  llvmPackages,
  wasm-bindgen-cli_0_2_93,
  binaryen,
  zip,
}:

let

  # apply upstream fix https://github.com/wasm-bindgen/wasm-bindgen/pull/4380,
  # as we cannot change the wasm-bindgen version, as it's pinned to 0.2.93.
  wasmBindgenCliPatched =
    let
      wasmBindgenCliDedupExportsPatch = fetchpatch {
        url = "https://github.com/wasm-bindgen/wasm-bindgen/commit/b375e974cf30a203f1ea7f6320ad32759c5cb9e6.patch";
        relative = "crates/cli-support";
        hash = "sha256-pejDKqNbtlpLLqNcdpwgxDSxsGxyv5V8/QeK+OCY3qw=";
      };
    in
    wasm-bindgen-cli_0_2_93.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        patch -p1 -d "$cargoDepsCopy"/*/wasm-bindgen-cli-support-* < ${wasmBindgenCliDedupExportsPatch}
      '';
    });
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "webadmin";
  version = "0.1.37";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webadmin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-82QvuLkp6j6nJs7jX4NRcnxZ+KNv9RREpM+x8dicfGo=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-na1HEueX8w7kuDp8LEtJ0nD1Yv39cyk6sEMpS1zix2s=";
  };
  __structuredAttrs = true;
  cargoHash = "sha256-qYIg1BthkpS77I6duYGGX168Y/IO8Mx4SWMQbE0BwDA=";

  postPatch = ''
    # Using local tailwindcss for compilation
    substituteInPlace Trunk.toml --replace-fail "npx tailwindcss" "tailwindcss"
  '';

  nativeBuildInputs = [
    binaryen
    llvmPackages.bintools-unwrapped
    nodejs
    npmHooks.npmConfigHook
    tailwindcss_3
    trunk
    # needs to match with wasm-bindgen version in upstreams Cargo.lock
    wasmBindgenCliPatched

    zip
  ];

  env.NODE_PATH = "$npmDeps";

  buildPhase = ''
    trunk build --offline --frozen --release
  '';

  installPhase = ''
    cd dist
    mkdir -p $out
    zip -r $out/webadmin.zip *
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web administration module for the Stalwart server";
    homepage = "https://github.com/stalwartlabs/webadmin";
    changelog = "https://github.com/stalwartlabs/webadmin/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    inherit (stalwart_0_15.meta) maintainers;
  };
})
