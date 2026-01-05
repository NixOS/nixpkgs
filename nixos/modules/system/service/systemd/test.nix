# Run:
#   nix-build -A nixosTests.modularService

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

      # Test input

      system.services.foo = {
        process = {
          argv = [
            hello'
            "--greeting"
            "hoi"
          ];
        };
      };
      system.services.bar = {
        process = {
          argv = [
            hello'
            "--greeting"
            "hoi"
          ];
        };
        systemd.service = {
          serviceConfig.X-Bar = "lol crossbar whatever";
        };
        services.db = {
          process = {
            argv = [
              hello'
              "--greeting"
              "Hi, I'm a database, would you believe it"
            ];
          };
          systemd.service = {
            serviceConfig.RestartSec = "42";
          };
        };
      };

      # irrelevant stuff
      system.stateVersion = "25.05";
      fileSystems."/".device = "/test/dummy";
      boot.loader.grub.enable = false;
    }
  );

  inherit (machine.config.system.build) toplevel;
in
runCommand "test-modular-service-systemd-units"
  {
    passthru = {
      inherit
        machine
        toplevel
        ;
    };
  }
  ''
    echo ${toplevel}/etc/systemd/system/foo.service:
    cat -n ${toplevel}/etc/systemd/system/foo.service
    (
      set -x
      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "hoi"' ${toplevel}/etc/systemd/system/foo.service >/dev/null

      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "hoi"' ${toplevel}/etc/systemd/system/bar.service >/dev/null
      grep -F 'X-Bar=lol crossbar whatever' ${toplevel}/etc/systemd/system/bar.service >/dev/null

      grep    'ExecStart="${hello}/bin/hello" "--greeting" ".*database.*"' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null
      grep -F 'RestartSec=42' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null

      [[ ! -e ${toplevel}/etc/systemd/system/foo.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar-db.socket ]]
    )
    echo 🐬👍
    touch $out
  ''
