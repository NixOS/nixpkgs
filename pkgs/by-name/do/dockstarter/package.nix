{
  bash,
  coreutils,
  fetchFromGitHub,
  git,
  lib,
  makeWrapper,
  ncurses,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "dockstarter";
  version = "unstable-2022-10-26";

  src = fetchFromGitHub {
    owner = "ghostwriters";
    repo = "dockstarter";
    rev = "a1b6b6e29aa135c2a61ea67ca05e9e034856ca08";
    hash = "sha256-G26DFme6YaizdE5oHBo/IqV+1quu07Bp+IykXtO/GgA=";
  };

  dontBuild = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 main.sh $out/bin/ds
    wrapProgram $out/bin/ds --prefix PATH : ${
      lib.makeBinPath [
        bash
        coreutils
        git
        ncurses
      ]
    }
  '';

  meta = with lib; {
    description = "Make it quick and easy to get up and running with Docker";
    homepage = "https://dockstarter.com";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "ds";
  };
}
