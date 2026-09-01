# Run:
#   nix-build -A nixosTests.modularUserServiceUnit

{
  evalSystem,
  runCommand,
  hello,
  ...
}:

let
  machine = evalSystem (
    { lib, ... }:
    let
      hello' = lib.getExe hello;
    in
    {
      users.users.alice = {
        isNormalUser = true;
        services.hello.process.argv = [
          hello'
          "--greeting"
          "hi alice"
        ];
        services.bar = {
          process.argv = [
            hello'
            "--greeting"
            "bar"
          ];
          services.db.process.argv = [
            hello'
            "--greeting"
            "bar-db"
          ];
        };
      };

      users.users.bob = {
        isNormalUser = true;
        # Same service name as alice — must not collide.
        services.hello.process.argv = [
          hello'
          "--greeting"
          "hi bob"
        ];
      };

      system.stateVersion = "26.05";
      fileSystems."/" = {
        device = "/test/dummy";
        fsType = "auto";
      };
      boot.loader.grub.enable = false;
    }
  );

  inherit (machine.config.system.build) toplevel;

  # The per-user profile is built as environment.etc."profiles/per-user/<name>".source.
  # It is a buildEnv derivation whose paths include the user-services package.
  aliceProfile = machine.config.environment.etc."profiles/per-user/alice".source;
  bobProfile = machine.config.environment.etc."profiles/per-user/bob".source;

  # Extract the user-services-* package from the buildEnv paths for symlink-target checks.
  aliceServicePkg = builtins.head (
    builtins.filter (
      p: builtins.match ".*user-services-alice.*" (toString p) != null
    ) aliceProfile.paths
  );

  bobServicePkg = builtins.head (
    builtins.filter (p: builtins.match ".*user-services-bob.*" (toString p) != null) bobProfile.paths
  );
in
runCommand "test-modular-user-service-systemd-units"
  {
    passthru = {
      inherit
        machine
        toplevel
        aliceProfile
        bobProfile
        aliceServicePkg
        bobServicePkg
        ;
    };
  }
  ''
    (
      set -x

      # Global units exist in /etc/systemd/user/ with double-dash prefix.
      [[ -e ${toplevel}/etc/systemd/user/alice--hello.service ]]
      [[ -e ${toplevel}/etc/systemd/user/bob--hello.service ]]
      [[ -e ${toplevel}/etc/systemd/user/alice--bar.service ]]
      [[ -e ${toplevel}/etc/systemd/user/alice--bar-db.service ]]

      # Global units must NOT have WantedBy= (auto-start suppressed system-wide).
      grep -v 'WantedBy=' ${toplevel}/etc/systemd/user/alice--hello.service

      # Per-user profile for alice: local names exposed via symlinks.
      [[ -L ${aliceProfile}/share/systemd/user/hello.service ]]
      [[ -L ${aliceProfile}/share/systemd/user/bar.service ]]
      [[ -L ${aliceProfile}/share/systemd/user/bar-db.service ]]

      # Auto-start symlinks in default.target.wants/.
      [[ -L ${aliceProfile}/share/systemd/user/default.target.wants/hello.service ]]
      [[ -L ${aliceProfile}/share/systemd/user/default.target.wants/bar.service ]]
      [[ -L ${aliceProfile}/share/systemd/user/default.target.wants/bar-db.service ]]

      # Alice's hello.service symlink resolves to alice-- global unit, not bob--.
      [[ $(readlink ${aliceServicePkg}/share/systemd/user/hello.service) == *alice--hello* ]]

      # Bob's profile has its own hello.service resolving to bob-- global unit.
      [[ -L ${bobProfile}/share/systemd/user/hello.service ]]
      [[ $(readlink ${bobServicePkg}/share/systemd/user/hello.service) == *bob--hello* ]]

      # ExecStart in global unit contains the correct greeting.
      grep '"hi alice"' ${toplevel}/etc/systemd/user/alice--hello.service
      grep '"hi bob"' ${toplevel}/etc/systemd/user/bob--hello.service
    )
    touch $out
  ''
