{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "procodile";
  gemdir = ./.;
  exes = [ "procodile" ];

  passthru.updateScript = bundlerUpdateScript "procodile";

<<<<<<< HEAD
  meta = {
    description = "Run processes in the background (and foreground) on Mac & Linux from a Procfile (for production and/or development environments)";
    homepage = "https://github.com/adamcooke/procodile";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Run processes in the background (and foreground) on Mac & Linux from a Procfile (for production and/or development environments)";
    homepage = "https://github.com/adamcooke/procodile";
    license = with licenses; mit;
    maintainers = with maintainers; [
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "procodile";
  };
}
