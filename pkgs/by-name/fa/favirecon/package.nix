{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "favirecon";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/CnhvcFNLNj8dFqypgXmOkteKepNmIH1icOXnldA/T8=";
  };

  vendorHash = "sha256-v/SBkfyO+NI+LXBK2OOTchmydIw69ycNF6amPOVt4rA=";

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
