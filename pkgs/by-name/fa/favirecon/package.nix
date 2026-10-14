{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "favirecon";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LgwwkHKKsGMOTi6VX/Fc4+vAYUc044i1CrxQO3Ci7nQ=";
  };

  vendorHash = "sha256-KRNzKPYCcOOvi7kP6fRMh7LBkMwSssmvUoRlH+jZPu8=";

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Tool to detect technologies, WAF, exposed panels and known services";
    homepage = "https://github.com/edoardottt/favirecon";
    changelog = "https://github.com/edoardottt/favirecon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "favirecon";
  };
})
