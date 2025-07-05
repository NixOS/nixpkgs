{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
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
    ./env-path.patch
  ];

  postPatch = ''
    substituteInPlace src/config/config.go \
      --replace-fail "%ENV_PATH%" ${env-dir}
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/explo
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spotify's \"Discover Weekly\" for self-hosted music systems";
    homepage = "https://github.com/LumePart/Explo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lilacious ];
    mainProgram = "explo";
  };
})
