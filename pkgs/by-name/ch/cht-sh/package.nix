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
<<<<<<< HEAD
  version = "0-unstable-2025-12-23";
=======
  version = "0-unstable-2025-08-08";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "chubin";
    repo = "cheat.sh";
<<<<<<< HEAD
    rev = "031a5d3887f035aaa3bf1a3f83dff4fde2aac53d";
    sha256 = "T6v58bmdA3EvC4QUgCR+FJLonN3QdHpkdvNGauq/i5Q=";
=======
    rev = "b714a5f0d56427924a7871f083fd05e7ede6b0e4";
    sha256 = "JkqHxHgs7gUk511CSJ/sLEBWCAYig1lqfslhABDNMGI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fgaz
      evanjs
    ];
    homepage = "https://github.com/chubin/cheat.sh";
    mainProgram = "cht.sh";
  };
}
