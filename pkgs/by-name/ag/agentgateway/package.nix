{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agentgateway";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "agentgateway";
    repo = "agentgateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tHz5NwP2oihOObjG/YEeKYk4VU7Ui9WjK2XDvrf/kaI=";
  };

  cargoHash = "sha256-bVwPCIs8A7TlPX4phc9w8l1UpiPShRTN7n08aS5MA7U=";

  cargoBuildFlags = [
    "--package"
    "agentgateway-app"
  ];

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    patchShebangs tools/report_build_info.sh
  '';

  env.VERSION = finalAttrs.version;

  # Tests require network access and external services
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gateway for Model Context Protocol and Agent-to-Agent protocol servers";
    homepage = "https://github.com/agentgateway/agentgateway";
    changelog = "https://github.com/agentgateway/agentgateway/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4min0 ];
    mainProgram = "agentgateway";
  };
})
