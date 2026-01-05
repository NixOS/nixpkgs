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

stdenv.mkDerivation (finalAttrs: {
  pname = "matrix-sdk-crypto-nodejs";
  version = "0.4.0-beta.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-rust-sdk-crypto-nodejs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Rl0xtaEj2RnW9HPN94hjETwiMInxT1XGa1BocldQAPs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4AC+l52I8Z3sXiViNPe6GLCl1Z+GpqjbwkcFX6BhxDA=";
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

    local -r outPath="$out/lib/node_modules/@matrix-org/${finalAttrs.pname}"
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
})
