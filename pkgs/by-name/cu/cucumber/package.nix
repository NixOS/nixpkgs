{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "cucumber";
  gemdir = ./.;
  exes = [ "cucumber" ];

  passthru.updateScript = bundlerUpdateScript "cucumber";

<<<<<<< HEAD
  meta = {
    description = "Tool for executable specifications";
    homepage = "https://cucumber.io/";
    changelog = "https://github.com/cucumber/cucumber-ruby/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "cucumber";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tool for executable specifications";
    homepage = "https://cucumber.io/";
    changelog = "https://github.com/cucumber/cucumber-ruby/blob/main/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "cucumber";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      manveru
      nicknovitski
      anthonyroussel
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
