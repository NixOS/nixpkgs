{
  bundlerApp,
  defaultGemConfig,
  bundlerUpdateScript,
  lib,
  makeWrapper,
  puppet-bolt,
  testers,
}:

(bundlerApp {
  pname = "bolt";

  gemdir = ./.;
  exes = [ "bolt" ];
  nativeBuildInputs = [ makeWrapper ];

  gemConfig = defaultGemConfig // {
    bolt = attrs: {
      # scripts in libexec will be executed by remote host,
      # so shebangs should remain unchanged
      dontPatchShebangs = true;
    };
  };

  postBuild = ''
    # Set BOLT_GEM=1 to remove warning
    wrapProgram $out/bin/bolt --set BOLT_GEM 1
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = puppet-bolt;
      version = (import ./gemset.nix).bolt.version;
    };
    updateScript = bundlerUpdateScript "puppet-bolt";
  };

  meta = with lib; {
    description = "Execute commands remotely over SSH and WinRM";
    homepage = "https://github.com/puppetlabs/bolt";
    changelog = "https://github.com/puppetlabs/bolt/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    mainProgram = "bolt";
    maintainers = with maintainers; [
      uvnikita
      anthonyroussel
    ];
    platforms = platforms.unix;
  };
}).overrideAttrs
  (old: {
    name = "puppet-bolt-${(import ./gemset.nix).bolt.version}";
  })
