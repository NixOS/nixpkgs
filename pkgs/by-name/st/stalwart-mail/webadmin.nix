{
  lib,
  rustPlatform,
  fetchFromGitHub,
  trunk-ng,
  tailwindcss,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  llvmPackages,
  wasm-bindgen-cli,
  binaryen,
  zip,
}:

rustPlatform.buildRustPackage rec {
  pname = "webadmin";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webadmin";
    rev = "refs/tags/v${version}";
    hash = "sha256-YglpdxZT5CyFLla6uXTKPtq9EbA9SEQacyR9KNToYT0=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-na1HEueX8w7kuDp8LEtJ0nD1Yv39cyk6sEMpS1zix2s=";
  };

  cargoHash = "sha256-piZ+oLL8FqS8Ishi7byYfdedkszreGuxI56pTLcYXn4=";

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
    trunk-ng
    wasm-bindgen-cli
    zip
  ];

  NODE_PATH = "$npmDeps";

  buildPhase = ''
    trunk-ng build --offline --verbose --release
  '';

  installPhase = ''
    cd dist
    mkdir -p $out
    zip -r $out/webadmin.zip *
  '';

  meta = with lib; {
    description = "Secure & modern all-in-one mail server Stalwart (webadmin module)";
    homepage = "https://github.com/stalwartlabs/webadmin";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/${version}/CHANGELOG";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
