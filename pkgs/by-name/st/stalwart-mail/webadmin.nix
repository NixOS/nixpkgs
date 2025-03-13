{
  lib,
  rustPlatform,
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

rustPlatform.buildRustPackage rec {
  pname = "webadmin";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webadmin";
    tag = "v${version}";
    hash = "sha256-KtCSP7PP1LBTcP1LFdEmom/4G8or87oA6ml6MXOhATk=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-na1HEueX8w7kuDp8LEtJ0nD1Yv39cyk6sEMpS1zix2s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VXbFQLMtqypQlisirKhlfu9PYgmEryJx85GRqlRslNY=";

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
    changelog = "https://github.com/stalwartlabs/webadmin/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ onny ];
  };
}
