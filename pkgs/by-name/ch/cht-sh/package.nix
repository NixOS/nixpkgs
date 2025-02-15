{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  makeWrapper,
  curl,
  ncurses,
  rlwrap,
  xsel,
}:

stdenv.mkDerivation {
  pname = "cht.sh";
  version = "0-unstable-2025-02-01";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "chubin";
    repo = "cheat.sh";
    rev = "139f8c2fb348a7028a9bac5474ca20ea00b13543";
    sha256 = "rvWYdkNaIZ1Xl6odtI2L2o/GhRevfTOJ5hZ/P/MNXiw=";
  };

  # Fix ".cht.sh-wrapped" in the help message
  postPatch = "substituteInPlace share/cht.sh.txt --replace '\${0##*/}' cht.sh";

  installPhase = ''
    install -m755 -D share/cht.sh.txt "$out/bin/cht.sh"

    # install shell completion files
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv share/bash_completion.txt $out/share/bash-completion/completions/cht.sh
    cp share/zsh.txt $out/share/zsh/site-functions/_cht

    wrapProgram "$out/bin/cht.sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          curl
          rlwrap
          ncurses
          xsel
        ]
      }"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/chubin/cheat.sh.git";
  };

  meta = with lib; {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = licenses.mit;
    maintainers = with maintainers; [
      fgaz
      evanjs
    ];
    homepage = "https://github.com/chubin/cheat.sh";
    mainProgram = "cht.sh";
  };
}
