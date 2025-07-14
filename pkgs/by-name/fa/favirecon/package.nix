{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "favirecon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${version}";
    hash = "sha256-nL5W4i4NJEjhkiO83hL9qK4XCIT5fnwRshyDkU1fASk=";
  };

  vendorHash = "sha256-PRLXVuqth9z0FkaMqUlEue1BFTI37oiobKOg3JvBYGU=";

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
