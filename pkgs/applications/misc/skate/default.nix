{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    hash = "sha256-Kum8IdgvRC75RLafCac0fkNn/VKvWFW48IK5tqLH/ME=";
  };

  proxyVendor = true;
  vendorHash = "sha256-/qZB/GGEkoqRoNhEmZw9Q2lsUPZRg5/xVxWgdBZTMLk=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    changelog = "https://github.com/charmbracelet/skate/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda penguwin ];
    mainProgram = "skate";
  };
}
