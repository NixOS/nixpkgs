{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "railway";
  version = "4.64.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0Zgdazs6AANKa3QtRHuYmudLpkvMHAzsaTCg3/cSN2o=";
  };

  cargoHash = "sha256-K1W8tn3Nr/PqWHHHF6mGsNqoAzekjEjqAoa6/4MZKfI=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  postInstall = ''
    wrapProgram $out/bin/railway \
      --set RAILWAY_NO_AUTO_UPDATE true
  '';

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
})
