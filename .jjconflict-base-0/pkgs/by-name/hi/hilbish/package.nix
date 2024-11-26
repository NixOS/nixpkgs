{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hilbish";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "refs/tags/v${version}";
    hash = "sha256-rDE9zxkCnnvc1OWd4Baei/Bw9KdFRV7DOorxLSD/KhM";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorHash = "sha256-8t3JBQEAmWcAlgA729IRpiewlgnRd5DQxHLTfwquE3o";

  ldflags = [
    "-s"
    "-w"
    "-X main.dataDir=${placeholder "out"}/share/hilbish"
  ];

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r docs -t $out/share/hilbish/
    cp -r libs -t $out/share/hilbish/
    cp -r nature $out/share/hilbish/
  '';

  meta = with lib; {
    description = "Interactive Unix-like shell written in Go";
    mainProgram = "hilbish";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ moni ];
    license = licenses.mit;
  };
}
