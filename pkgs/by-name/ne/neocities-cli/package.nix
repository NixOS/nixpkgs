{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp {
  pname = "neocities";
  gemdir = ./.;
  exes = [ "neocities" ];

  passthru.updateScript = bundlerUpdateScript "neocities";

  meta = with lib; {
    description = "The Neocities Gem - A CLI and library for using the Neocities web site API.";
    homepage = "https://github.com/neocities/neocities-ruby";
    license = licenses.mit;
    mainProgram = "neocities";
    maintainers = with maintainers; [ dawoox ];
    platforms = platforms.unix;
  };
}

