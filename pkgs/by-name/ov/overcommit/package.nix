{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  git,
  makeWrapper,
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
    updateScript = bundlerUpdateScript "overcommit";
  };

  meta = with lib; {
    description = "Tool to manage and configure Git hooks";
    homepage = "https://github.com/sds/overcommit";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      anthonyroussel
    ];
    platforms = platforms.unix;
  };
}
