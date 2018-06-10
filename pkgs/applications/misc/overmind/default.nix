{ stdenv, buildGoPackage, fetchFromGitHub, tmux, makeWrapper }:

buildGoPackage rec {
  name = "overmind-${version}";
  version = "1.1.1";
  goPackagePath = "github.com/DarthSim/overmind";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$bin/bin/overmind" --prefix PATH : "${stdenv.lib.makeBinPath [ tmux ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "overmind";
    rev = "v${version}";
    sha256 = "0gdsbm54ln07jv1kgg53fiavx18xxw4f21lfcdl74ijk6bx4jbzv";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/DarthSim/;
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
