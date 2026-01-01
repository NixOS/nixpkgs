{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "corundum";
  gemdir = ./.;
  exes = [ "corundum-skel" ];

  passthru.updateScript = bundlerUpdateScript "corundum";

<<<<<<< HEAD
  meta = {
    description = "Tool and libraries for maintaining Ruby gems";
    homepage = "https://github.com/nyarly/corundum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nyarly
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool and libraries for maintaining Ruby gems";
    homepage = "https://github.com/nyarly/corundum";
    license = licenses.mit;
    maintainers = with maintainers; [
      nyarly
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
