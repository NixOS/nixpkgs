{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "favirecon";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GpPqTtbSVLwNLKpxSb2YMZIOEHgfKn0U6K2f1ISrufc=";
  };

  vendorHash = "sha256-jjKDiow5sdwKpA1f+Dzkyb8wQuU26MHcafNYhk9H9MM=";

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
