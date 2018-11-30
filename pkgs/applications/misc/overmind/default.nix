{ stdenv, buildGoPackage, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoPackage rec {
  name = "overmind-${version}";
  version = "1.2.1";
  goPackagePath = "github.com/DarthSim/overmind";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$bin/bin/overmind" --prefix PATH : "${stdenv.lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "overmind";
    rev = "v${version}";
    sha256 = "11ws9rsy8ladjp1y3b6vva9sjmw4s24xc1w18lyhfz63xc908nfw";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/DarthSim/;
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
