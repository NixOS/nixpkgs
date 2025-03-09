{
  lib,
  rustPlatform,
  fetchFromGitHub,
  trunk,
  tailwindcss,
  fetchNpmDeps,
  nix-update-script,
  nodejs,
  npmHooks,
  llvmPackages,
  wasm-bindgen-cli,
  binaryen,
  zip,
}:

rustPlatform.buildRustPackage rec {
  pname = "webadmin";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webadmin";
    tag = "v${version}";
    hash = "sha256-0/XiYFQDqcpRS9DXPyKQwoifnEd2YxFiyDbV12zd2RU=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-na1HEueX8w7kuDp8LEtJ0nD1Yv39cyk6sEMpS1zix2s=";
  };

  cargoHash = "sha256-uyLGrCZvKiePHFG0C++ELwT/1FTH8c4baAUxV2ueHZ8=";

  postPatch = ''
    # Using local tailwindcss for compilation
    substituteInPlace Trunk.toml --replace-fail "npx tailwindcss" "tailwindcss"
  '';

  nativeBuildInputs = [
    binaryen
    llvmPackages.bintools-unwrapped
    nodejs
    npmHooks.npmConfigHook
    tailwindcss
    trunk
    # needs to match with wasm-bindgen version in upstreams Cargo.lock
    (wasm-bindgen-cli.override {
      version = "0.2.93";
      hash = "sha256-DDdu5mM3gneraM85pAepBXWn3TMofarVR4NbjMdz3r0=";
      cargoHash = "sha256-birrg+XABBHHKJxfTKAMSlmTVYLmnmqMDfRnmG6g/YQ=";
    })
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
