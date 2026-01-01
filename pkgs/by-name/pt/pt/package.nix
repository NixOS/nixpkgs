{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "pt";
  gemdir = ./.;
  exes = [ "pt" ];

  passthru.updateScript = bundlerUpdateScript "pt";

<<<<<<< HEAD
  meta = {
    description = "Minimalist command-line Pivotal Tracker client";
    homepage = "http://www.github.com/raul/pt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Minimalist command-line Pivotal Tracker client";
    homepage = "http://www.github.com/raul/pt";
    license = licenses.mit;
    maintainers = with maintainers; [
      ebzzry
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pt";
  };
}
