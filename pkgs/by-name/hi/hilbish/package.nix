{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hilbish";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    tag = "v${version}";
    hash = "sha256-rEBUrDdJBCywuSmsxFLl4+uSwz06km2nztH5aCGcGiE=";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorHash = "sha256-8t3JBQEAmWcAlgA729IRpiewlgnRd5DQxHLTfwquE3o=";

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

  meta = {
    description = "Interactive Unix-like shell written in Go";
    mainProgram = "hilbish";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with lib.maintainers; [ moni ];
    license = lib.licenses.mit;
  };
}
