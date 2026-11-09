{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubernix";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-guXoQ09tZ/qOEQomlIODED2f01DDFSQyyDNl7vLzahI=";
  };

  cargoHash = "sha256-AYWbXxCdtkKePmHTj6MkbLMsW060eB5Ym/o1Hus4FDw=";

  # Tests require network access
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    mainProgram = "kubernix";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ saschagrunert ];
    platforms = lib.platforms.linux;
  };
})
