{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "favirecon";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K8SISs94SRxLAW38GT/mOOvuBktg+y9vKh9BjoJKELM=";
  };

  vendorHash = "sha256-PA27sDdM8/qTEUo2fYbVowP8R50cPebVPn2SXUH1VHw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to detect technologies, WAF, exposed panels and known services";
    homepage = "https://github.com/edoardottt/favirecon";
    changelog = "https://github.com/edoardottt/favirecon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "favirecon";
  };
})
