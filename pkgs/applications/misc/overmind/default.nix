{ lib, buildGoPackage, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoPackage rec {
  pname = "overmind";
  version = "2.1.1";
  goPackagePath = "github.com/DarthSim/overmind";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "0akqn8s1mgk5q00gzh3ymq7nrnkyi6avyaxxvbxnjyq9bxsqz327";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
