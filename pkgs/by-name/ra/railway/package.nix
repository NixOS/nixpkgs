{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  openssl,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "railway";
  version = "5.31.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W3Ma8kzrocNUqRkcJOUsvvSC8oW/dDAyPjk3D6k7/RA=";
  };

  cargoHash = "sha256-ahOFeRT1xkiHBeucvbyXcmahBIGYV3dlMGBavKuQ6NY=";

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

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
