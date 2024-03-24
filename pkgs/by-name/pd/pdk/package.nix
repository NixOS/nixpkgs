{
  bundlerApp,
  bundlerUpdateScript,
  gnumake,
  lib,
  makeWrapper,
}:

bundlerApp {
  pname = "pdk";
  gemdir = ./.;
  exes = [ "pdk" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pdk --prefix PATH : ${lib.makeBinPath [ gnumake ]}
  '';

  passthru.updateScript = bundlerUpdateScript "pdk";

  meta = {
    description = "Puppet Development Kit";
    homepage = "https://github.com/puppetlabs/pdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ netali anthonyroussel ];
  };
}
