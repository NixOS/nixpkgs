{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp rec {
  pname = "coltrane";
  gemdir = ./.;
  exes = [ "coltrane" ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = with lib; {
    homepage = "https://github.com/pedrozath/coltrane";
    description = "Music calculation library/CLI";
    longDescription = ''
      coltrane allows to search for Notes, Chords, Scales for
      guitar, bass, piano and ukelele
    '';
    license = licenses.mit;
    maintainers = [ maintainers.panaeon ];
    mainProgram = "coltrane";
  };
}
