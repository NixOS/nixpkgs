{
  bundlerApp,
  bundlerUpdateScript,
  git,
  gnutar,
  gzip,
  lib,
  makeWrapper,
  r10k,
  testers,
}:

bundlerApp {
  pname = "r10k";
  gemdir = ./.;
  exes = [ "r10k" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/r10k --prefix PATH : ${
      lib.makeBinPath [
        git
        gnutar
        gzip
      ]
    }
  '';

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe r10k} version";
      package = r10k;
      version = (import ./gemset.nix).r10k.version;
    };
    updateScript = bundlerUpdateScript "r10k";
  };

  meta = {
    description = "Puppet environment and module deployment";
    homepage = "https://github.com/puppetlabs/r10k";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      zimbatm
      manveru
      nicknovitski
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
    mainProgram = "r10k";
  };
}
