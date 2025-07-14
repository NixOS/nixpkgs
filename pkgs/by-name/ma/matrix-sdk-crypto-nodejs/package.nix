{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  napi-rs-cli,
  nodejs,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "matrix-sdk-crypto-nodejs";
  version = "0.3.0-beta.1-unstable-2025-02-11";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-rust-sdk-crypto-nodejs";
    rev = "f74a37e9c8f5af005119464a3501346b8c22695f";
    hash = "sha256-QHKFD9PPUXMb78GjSabk3vWnd5DIhTjtBZL8e/Tuw0g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-hKuFu8T7zCXlmiG7k3WJsLSDYhIu6vT5la+AZOmz8EM=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    napi-rs-cli
    nodejs
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  buildPhase = ''
    runHook preBuild

    npm run release-build --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local -r outPath="$out/lib/node_modules/@matrix-org/${pname}"
    mkdir -p "$outPath"
    cp package.json index.js index.d.ts matrix-sdk-crypto.*.node "$outPath"

    runHook postInstall
  '';

  meta = with lib; {
    description = "No-network-IO implementation of a state machine that handles E2EE for Matrix clients";
    homepage = "https://github.com/matrix-org/matrix-rust-sdk-crypto-nodejs";
    changelog = "https://github.com/matrix-org/matrix-rust-sdk-crypto-nodejs/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      winter
      dandellion
    ];
    inherit (nodejs.meta) platforms;
    # napi_build doesn't handle most cross-compilation configurations
    broken = (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) || stdenv.hostPlatform.isStatic;
  };
}
