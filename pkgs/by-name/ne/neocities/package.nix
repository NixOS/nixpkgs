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
    description = "CLI and library for interacting with the Neocities API";
    homepage = "https://github.com/neocities/neocities-ruby";
    license = licenses.mit;
    mainProgram = "neocities";
    maintainers = with maintainers; [ dawoox ];
    platforms = platforms.unix;
  };
}

