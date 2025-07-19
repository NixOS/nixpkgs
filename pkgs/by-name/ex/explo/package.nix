{
  lib,
  replaceVars,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  # workaround hardcoded .env path
  env-dir ? "/var/lib/explo/.env",
}:

buildGoModule (finalAttrs: {
  pname = "explo";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "LumePart";
    repo = "Explo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LCw7uYQanUTxfM/BqHQe0GY4iz6dCvCPuP4TkS82GzM=";
  };

  vendorHash = "sha256-uDGtIgRUYHUmsOR0c59TaHX23RQgBL9JJwdtI2fMSS0=";

  patches = [
    (replaceVars ./env-path.patch { ENV_PATH = env-dir; })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/explo
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spotify's \"Discover Weekly\" for self-hosted music systems";
    homepage = "https://github.com/LumePart/Explo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lilacious ];
    mainProgram = "explo";
  };
})
