{ lib, buildGoPackage, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoPackage rec {
  pname = "overmind";
  version = "2.0.3";
  goPackagePath = "github.com/DarthSim/overmind";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$bin/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c551c240lqxdjg0jj01rh2fyhwls02k5lczlxacj05prp1plz9p";
  };

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
