{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "favirecon";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${version}";
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
    changelog = "https://github.com/edoardottt/favirecon/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "favirecon";
  };
}
