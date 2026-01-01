{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "neocities";
  gemdir = ./.;
  exes = [ "neocities" ];

  passthru.updateScript = bundlerUpdateScript "neocities";

<<<<<<< HEAD
  meta = {
    description = "CLI and library for interacting with the Neocities API";
    homepage = "https://github.com/neocities/neocities-ruby";
    license = lib.licenses.mit;
    mainProgram = "neocities";
    maintainers = with lib.maintainers; [ dawoox ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "CLI and library for interacting with the Neocities API";
    homepage = "https://github.com/neocities/neocities-ruby";
    license = licenses.mit;
    mainProgram = "neocities";
    maintainers = with maintainers; [ dawoox ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
