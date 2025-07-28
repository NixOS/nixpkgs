{
  lib,
  rustPlatform,
  stalwart-mail,
  fetchFromGitHub,
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "webadmin";
  version = "0.1.31";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webadmin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4+R7QQT0cbKYe6WzgvzreOFULBnWdNcbPC27f4r+M0g=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-na1HEueX8w7kuDp8LEtJ0nD1Yv39cyk6sEMpS1zix2s=";
  };

  cargoHash = "sha256-Q05+wH9+NfkfmEDJFLuWVQ7wuDeEu9h1XmOMN6SYdyU=";

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
    wasm-bindgen-cli_0_2_93

    zip
  ];

  NODE_PATH = "$npmDeps";

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
    description = "Secure & modern all-in-one mail server Stalwart (webadmin module)";
    homepage = "https://github.com/stalwartlabs/webadmin";
    changelog = "https://github.com/stalwartlabs/webadmin/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    inherit (stalwart-mail.meta) maintainers;
  };
})
