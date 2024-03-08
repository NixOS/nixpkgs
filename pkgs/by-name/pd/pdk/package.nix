{ lib,
  bundlerApp,
  bundlerUpdateScript,
  makeWrapper,
  gnumake
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

  meta = with lib; {
    description = "Puppet Development Kit";
    homepage    = "https://github.com/puppetlabs/pdk";
    license     = licenses.asl20;
    maintainers = with maintainers; [ netali ];
  };
}
