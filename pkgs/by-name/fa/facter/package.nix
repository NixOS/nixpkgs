{
  bundlerApp,
  bundlerUpdateScript,
  coreutils,
  facter,
  gnugrep,
  iproute2,
  lib,
  makeWrapper,
  nettools,
  pciutils,
  procps,
  stdenv,
  testers,
  util-linux,
  virt-what,
  zfs,
}:

bundlerApp {
  pname = "facter";
  gemdir = ./.;
  exes = [ "facter" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild =
    let
      runtimeDependencies =
        [
          coreutils
          gnugrep
          nettools
          pciutils
          procps
          util-linux
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          iproute2
          virt-what
          zfs
        ];
    in
    ''
      wrapProgram $out/bin/facter --prefix PATH : ${lib.makeBinPath runtimeDependencies}
    '';

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe facter} --version";
      package = facter;
      version = (import ./gemset.nix).facter.version;
    };
    updateScript = bundlerUpdateScript "facter";
  };

  meta = {
    changelog = "https://www.puppet.com/docs/puppet/latest/release_notes_facter.html";
    description = "System inventory tool";
    homepage = "https://github.com/puppetlabs/facter";
    license = lib.licenses.asl20;
    mainProgram = "facter";
    maintainers = with lib.maintainers; [
      womfoo
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
  };
}
