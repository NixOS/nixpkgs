{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  delta,
}:

buildGoModule rec {
  pname = "diffnav";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    rev = "refs/tags/v${version}";
    hash = "sha256-QDPH7vBoA4YCmC+CLmeBdspwOhFEV3iSiyBYX6lwOLA=";
  };

  vendorHash = "sha256-cDA5qstTRApt4DXcakNLR5nsyh9i7z2Qrvp6q/OoYhY=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
  postInstall = ''
    wrapProgram $out/bin/diffnav \
      --prefix PATH : ${lib.makeBinPath [ delta ]}
  '';

  meta = {
    changelog = "https://github.com/dlvhdr/diffnav/releases/tag/${src.rev}";
    description = "Git diff pager based on delta but with a file tree, à la GitHub";
    homepage = "https://github.com/dlvhdr/diffnav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "diffnav";
  };
}
