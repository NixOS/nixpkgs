{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  makeWrapper,
  curl,
  ncurses,
  gtk3,
  pkg-config,
  scoreDirectory ? "$HOME/.local/share",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dopewars";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "benmwebb";
    repo = "dopewars";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CpgqRYmrfOFxhC7yAS2OqRBi4r3Vesq3+7a0q5rc3vM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    curl
    gtk3
    ncurses
  ];

  # remove the denied setting of setuid bit permission
  patches = [ ./0001-remove_setuid.patch ];

  # run dopewars with -f so that it finds its scoreboard file in ~/.local/share
  postInstall = ''
    wrapProgram $out/bin/dopewars \
      --run 'mkdir -p ${scoreDirectory}' \
      --add-flags '-f ${scoreDirectory}/dopewars.sco'
  '';

  meta = with lib; {
    description = "Game simulating the life of a drug dealer in New York";
    homepage = "https://dopewars.sourceforge.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ geri1701 ];
    mainProgram = "dopewars";
    platforms = platforms.unix;
  };
})
