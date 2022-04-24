{ lib, stdenv, fetchgit, ncurses, portmidi }:
stdenv.mkDerivation {
  pname = "orca-c";
  version = "unstable-2021-02-13";

  src = fetchgit {
    url = "https://git.sr.ht/~rabbits/orca";
    rev = "5ba56ca67baae3db140f8b7a2b2fc46bbac5602f";
    sha256 = "sha256-bbIH0kyHRTcMGXV3WdBQIH1br0FyIzKKL88wqpGZ0NY=";
  };

  buildInputs = [ ncurses portmidi ];

  postPatch = ''
    patchShebangs tool
    sed -i tool \
      -e 's@ncurses_dir=.*@ncurses_dir="${ncurses}"@' \
      -e 's@portmidi_dir=.*@portmidi_dir="${portmidi}"@' tool
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install build/orca $out/bin/orca

    runHook postInstall
  '';

  meta = with lib; {
    description = "An esoteric programming language designed to quickly create procedural sequencers";
    homepage = "https://git.sr.ht/~rabbits/orca";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ netcrns ];
    mainProgram = "orca";
  };
}
