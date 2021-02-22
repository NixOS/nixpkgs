{ lib, buildGoPackage, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoPackage rec {
  pname = "overmind";
  version = "2.2.0";
  goPackagePath = "github.com/DarthSim/overmind";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "00v6l4138vv32bqfkzrhk4hfl52a00rlg9ywhp4difgrnz7zj6xb";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
