{ lib, buildGoModule, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoModule rec {
  pname = "overmind";
  version = "2.3.0";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vmmSsg0JneMseFCcx/no2x/Ghppmyiod8ZAIb4JWW9I=";
  };

  vendorSha256 = "sha256-QIKyLknPvmt8yiUCSCIqha8h9ozDGeQnKSM9Vwus0uY=";

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
