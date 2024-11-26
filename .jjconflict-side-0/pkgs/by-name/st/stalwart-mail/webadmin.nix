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
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webadmin";
    rev = "refs/tags/v${version}";
    hash = "sha256-jaNBYVIIxYjle4JQJdcvzl9f5slRvGPKqtzR2WGc0LE=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-na1HEueX8w7kuDp8LEtJ0nD1Yv39cyk6sEMpS1zix2s=";
  };

  cargoHash = "sha256-r4j4+vwmx8JJn3+6i6z6dYBOr6Efdid6qtw9oolCTW8=";

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

  meta = with lib; {
    description = "Secure & modern all-in-one mail server Stalwart (webadmin module)";
    homepage = "https://github.com/stalwartlabs/webadmin";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/${version}/CHANGELOG";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
