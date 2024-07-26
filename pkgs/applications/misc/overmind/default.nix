{ lib, buildGoModule, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoModule rec {
  pname = "overmind";
  version = "2.4.0";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cpsTytV1TbvdR7XUKkp4GPD1qyt1qnmY6qOsge01swE=";
  };

  vendorHash = "sha256-ndgnFBGtVFc++h+EnA37aY9+zNsO5GDrTECA4TEWPN4=";

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
