{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "deja";
  version = "0.3.2";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "Giammarco-Ferranti";
    repo = "deja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ngjnrEq7x6OQ9uFGKmEvbAG7rPtjYX0xLK8110WSZUQ=";
  };

  vendorHash = "sha256-KmLdMK94cGOXMPJwWS6NgLB5OiNmJbszHdnLzauqJm8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Predictive inline shell autosuggestions for zsh";
    homepage = "https://github.com/Giammarco-Ferranti/deja";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "deja";
  };
})
