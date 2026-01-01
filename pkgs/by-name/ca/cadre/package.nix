{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "cadre";
  gemdir = ./.;
  exes = [ "cadre" ];

  passthru.updateScript = bundlerUpdateScript "cadre";

<<<<<<< HEAD
  meta = {
    description = "Toolkit to add Ruby development - in-editor coverage, libnotify of test runs";
    homepage = "https://github.com/nyarly/cadre";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nyarly
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Toolkit to add Ruby development - in-editor coverage, libnotify of test runs";
    homepage = "https://github.com/nyarly/cadre";
    license = licenses.mit;
    maintainers = with maintainers; [
      nyarly
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
