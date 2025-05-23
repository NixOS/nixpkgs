{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp rec {
  pname = "cucumber";
  gemdir = ./.;
  exes = [ "cucumber" ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = with lib; {
    description = "Tool for executable specifications";
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
