{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
}:

buildGoModule rec {
  pname = "ghbackup";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "qvl";
    repo = "ghbackup";
    rev = "v${version}";
    hash = "sha256-3LSe805VrbUGjqjnhTJD2KBVZ4rq+4Z3l4d0I1MrBMA=";
  };

  patches = [ ./patches/fix-next-page-logic.patch ];

  postPatch = ''
    go mod init qvl.io/ghbackup
  '';

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = null;

  postFixup = ''
    wrapProgram $out/bin/${meta.mainProgram} \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  doCheck = false; # tests want to actually download from github

  meta = with lib; {
    description = "Backup your GitHub repositories with a simple command-line application written in Go.";
    homepage = "https://github.com/qvl/ghbackup";
    license = licenses.mit;
    mainProgram = "ghbackup";
    maintainers = with maintainers; [ lenny ];
  };
}
