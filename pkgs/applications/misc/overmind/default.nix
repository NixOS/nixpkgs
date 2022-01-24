{ lib, buildGoModule, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoModule rec {
  pname = "overmind";
  version = "2.2.2";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "zDjIwnhDoUj+zTAhtBa94dx7QhYMCTxv2DNUpeP8CP0=";
  };

  vendorSha256 = "KDMzR6qAruscgS6/bHTN6RnHOlLKCm9lxkr9k3oLY+Y=";

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
