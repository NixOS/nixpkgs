{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "mdl";
  gemdir = ./.;
  exes = [ "mdl" ];

  passthru.updateScript = bundlerUpdateScript "mdl";

<<<<<<< HEAD
  meta = {
    description = "Tool to check markdown files and flag style issues";
    homepage = "https://github.com/markdownlint/markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tool to check markdown files and flag style issues";
    homepage = "https://github.com/markdownlint/markdownlint";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gerschtli
      manveru
      nicknovitski
      totoroot
    ];
<<<<<<< HEAD
    platforms = lib.platforms.all;
=======
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
