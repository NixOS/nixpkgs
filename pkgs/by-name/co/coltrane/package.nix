{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "coltrane";
  gemdir = ./.;
  exes = [ "coltrane" ];

  passthru.updateScript = bundlerUpdateScript "coltrane";

  meta = with lib; {
    homepage = "https://github.com/pedrozath/coltrane";
    description = "Music calculation library/CLI";
    longDescription = ''
      coltrane allows to search for Notes, Chords, Scales for
      guitar, bass, piano and ukulele
    '';
    license = licenses.mit;
    maintainers = [ maintainers.panaeon ];
    mainProgram = "coltrane";
  };
}
