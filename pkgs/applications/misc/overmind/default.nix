{ stdenv, buildGoPackage, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoPackage rec {
  name = "overmind-${version}";
  version = "2.0.1";
  goPackagePath = "github.com/DarthSim/overmind";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$bin/bin/overmind" --prefix PATH : "${stdenv.lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "overmind";
    rev = "v${version}";
    sha256 = "1j3cpcfgacn5ic19sgrs1djn5jr4d7j7lxaz0vbaf414lrl76qz8";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/DarthSim/overmind;
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
