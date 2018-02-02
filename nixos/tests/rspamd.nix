{ system ? builtins.currentSystem }:
with import ../lib/testing.nix { inherit system; };
with pkgs.lib;
let
  initMachine = ''
    startAll
    $machine->waitForUnit("rspamd.service");
    $machine->succeed("id \"rspamd\" >/dev/null");
  '';
  checkSocket = socket: user: group: mode: ''
    $machine->succeed("ls ${socket} >/dev/null");
    $machine->succeed("[[ \"\$(stat -c %U ${socket})\" == \"${user}\" ]]");
    $machine->succeed("[[ \"\$(stat -c %G ${socket})\" == \"${group}\" ]]");
    $machine->succeed("[[ \"\$(stat -c %a ${socket})\" == \"${mode}\" ]]");
  '';
  simple = name: enableIPv6: makeTest {
    name = "rspamd-${name}";
    machine = {
      services.rspamd = {
        enable = true;
      };
      networking.enableIPv6 = enableIPv6;
    };
    testScript = ''
      startAll
      $machine->waitForUnit("multi-user.target");
      $machine->waitForOpenPort(11334);
      $machine->waitForUnit("rspamd.service");
      $machine->succeed("id \"rspamd\" >/dev/null");
      ${checkSocket "/run/rspamd/rspamd.sock" "rspamd" "rspamd" "660" }
      sleep 10;
      $machine->log($machine->succeed("systemctl cat rspamd.service"));
      $machine->log($machine->succeed("curl http://localhost:11334/auth"));
      $machine->log($machine->succeed("curl http://127.0.0.1:11334/auth"));
      ${optionalString enableIPv6 ''
        $machine->log($machine->succeed("curl http://[::1]:11334/auth"));
      ''}
    '';
  };
in
{
  simple = simple "simple" true;
  ipv4only = simple "ipv4only" false;
  bindports = makeTest {
    name = "rspamd-bindports";
    machine = {
      services.rspamd = {
        enable = true;
        bindSocket = [ "/run/rspamd.sock mode=0600 user=root group=root" ];
        bindUISocket = [ "/run/rspamd-worker.sock mode=0666 user=root group=root" ];
      };
    };

    testScript = ''
      ${initMachine}
      $machine->waitForFile("/run/rspamd.sock");
      ${checkSocket "/run/rspamd.sock" "root" "root" "600" }
      ${checkSocket "/run/rspamd-worker.sock" "root" "root" "666" }
      $machine->log($machine->succeed("rspamc -h /run/rspamd-worker.sock stat"));
      $machine->log($machine->succeed("curl --unix-socket /run/rspamd-worker.sock http://localhost/ping"));
    '';
  };
}
