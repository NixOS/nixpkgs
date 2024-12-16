{
  bundlerApp,
  bundlerUpdateScript,
  gnumake,
  lib,
  makeWrapper,
  pdk,
  testers,
}:

bundlerApp {
  pname = "pdk";
  gemdir = ./.;
  exes = [ "pdk" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pdk --prefix PATH : ${lib.makeBinPath [ gnumake ]}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = pdk;
      version = (import ./gemset.nix).pdk.version;
    };
    updateScript = bundlerUpdateScript "pdk";
  };

  meta = {
    changelog = "https://github.com/puppetlabs/pdk/blob/main/CHANGELOG.md";
    description = "Puppet Development Kit";
    homepage = "https://github.com/puppetlabs/pdk";
    license = lib.licenses.asl20;
    mainProgram = "pdk";
    maintainers = with lib.maintainers; [ netali anthonyroussel ];
  };
}
