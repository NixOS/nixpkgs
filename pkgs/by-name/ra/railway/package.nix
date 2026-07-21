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
  version = "5.27.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oggPYEVITztEASQ8FRDUGUmynR5kDFxhQL0IXcgama0=";
  };

  cargoHash = "sha256-hNNdAMYxk3xY44qZLdKLrgra9vibUj42PPJoQUVfHwk=";

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
