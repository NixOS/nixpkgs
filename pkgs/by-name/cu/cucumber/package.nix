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

  meta = with lib; {
    description = "A tool for executable specifications";
    homepage = "https://cucumber.io/";
    changelog = "https://github.com/cucumber/cucumber-ruby/blob/main/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "cucumber";
    maintainers = with maintainers; [
      manveru
      nicknovitski
      anthonyroussel
    ];
    platforms = platforms.unix;
  };
}
