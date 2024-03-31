{ lib, buildGoModule, fetchFromGitHub, tmux, which, makeWrapper }:

buildGoModule rec {
  pname = "overmind";
  version = "2.5.0";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/overmind" --prefix PATH : "${lib.makeBinPath [ tmux which ]}"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/reRiSeYf8tnSUJICMDp7K7XZCYvTDFInPJ1xFuAqRs=";
  };

  vendorHash = "sha256-6/S5Sf2vvCp2RpRqcJPVc9mvMuPVn4Kj9QpSIlu6YFU=";

  meta = with lib; {
    homepage = "https://github.com/DarthSim/overmind";
    description = "Process manager for Procfile-based applications and tmux";
    mainProgram = "overmind";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
