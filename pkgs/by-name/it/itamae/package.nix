{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "itamae";
  gemdir = ./.;
  exes = [ "itamae" ];

  passthru.updateScript = bundlerUpdateScript "itamae";

<<<<<<< HEAD
  meta = {
    description = "Simple and lightweight configuration management tool inspired by Chef";
    homepage = "https://itamae.kitchen/";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ refi64 ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Simple and lightweight configuration management tool inspired by Chef";
    homepage = "https://itamae.kitchen/";
    license = with licenses; mit;
    maintainers = with maintainers; [ refi64 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "itamae";
  };
}
