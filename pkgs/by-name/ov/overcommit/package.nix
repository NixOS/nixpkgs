{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  git,
  makeWrapper,
  overcommit,
  testers,
}:

bundlerApp {
  pname = "overcommit";
  gemdir = ./.;
  exes = [ "overcommit" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/overcommit --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = overcommit;
      version = (import ./gemset.nix).overcommit.version;
    };
    updateScript = bundlerUpdateScript "overcommit";
  };

  meta = {
    description = "Tool to manage and configure Git hooks";
    homepage = "https://github.com/sds/overcommit";
    changelog = "https://github.com/sds/overcommit/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "overcommit";
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
  };
}
