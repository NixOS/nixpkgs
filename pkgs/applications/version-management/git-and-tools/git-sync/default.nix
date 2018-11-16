{ stdenv, fetchFromGitHub, coreutils, gnugrep, gnused, makeWrapper, git
}:

stdenv.mkDerivation rec {
  name = "git-sync-${version}";
  version = "20151024";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "eb9adaf2b5fd65aac1e83d6544b9076aae6af5b7";
    sha256 = "01if8y93wa0mwbkzkzx2v1vqh47zlz4k1dysl6yh5rmppd1psknz";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-sync $out/bin/git-sync
  '';

  wrapperPath = with stdenv.lib; makeBinPath [
    coreutils
    git
    gnugrep
    gnused
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "A script to automatically synchronize a git repository";
    homepage = https://github.com/simonthum/git-sync;
    maintainers = with stdenv.lib.maintainers; [ imalison ];
    license = stdenv.lib.licenses.cc0;
    platforms = with stdenv.lib.platforms; unix;
  };
}
