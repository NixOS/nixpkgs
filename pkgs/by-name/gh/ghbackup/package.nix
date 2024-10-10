{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
}:

buildGoModule rec {
  pname = "ghbackup";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "voiapp";
    repo = "ghbackup";
    rev = "v${version}";
    hash = "sha256-R7vtxxk0fzOMd99lT1dRkSJV3ENdItAUu01twjjGRxI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = null;

  postPatch = ''
    # The source is a fork that has a patch applied,
    # but didn't rename the import. Thus we need to init
    # with the original package name.
    go mod init qvl.io/ghbackup
  '';

  postFixup = ''
    wrapProgram $out/bin/${meta.mainProgram} \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  doCheck = false; # tests want to actuallt download from github

  meta = with lib; {
    description = "Backup your GitHub repositories with a simple command-line application written in Go.";
    homepage = "https://github.com/voiapp/ghbackup";
    license = licenses.mit;
    mainProgram = "ghbackup";
    maintainers = with maintainers; [ lenny ];
  };
}
