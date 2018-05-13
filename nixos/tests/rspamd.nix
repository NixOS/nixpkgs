{ system ? builtins.currentSystem }:
with import ../lib/testing.nix { inherit system; };
with pkgs.lib;
let
  initMachine = ''
    startAll
    $machine->waitForUnit("multi-user.target");
    $machine->succeed("id \"rspamd\" >/dev/null");
  '';
  checkSocket = socket: user: group: mode: ''
    $machine->succeed("ls ${socket} >/dev/null");
    $machine->succeed("[[ \"\$(stat -c %U ${socket})\" == \"${user}\" ]]");
    $machine->succeed("[[ \"\$(stat -c %G ${socket})\" == \"${group}\" ]]");
    $machine->succeed("[[ \"\$(stat -c %a ${socket})\" == \"${mode}\" ]]");
  '';
  simple = name: socketActivation: makeTest {
    name = "rspamd-${name}";
    machine = {
      services.rspamd = {
        enable = true;
        socketActivation = socketActivation;
      };
    };
    testScript = ''
      ${initMachine}
      $machine->log($machine->succeed("systemctl cat rspamd.service"));
      ${if socketActivation then ''
        $machine->log($machine->succeed("systemctl cat rspamd-controller-1.socket"));
      '' else ''
        $machine->fail("systemctl cat rspamd-controller-1.socket");
        $machine->waitForFile("/run/rspamd/controller.sock");
      ''}
      $machine->log($machine->succeed("curl --unix-socket /run/rspamd/controller.sock http://localhost/auth"));
    '';
  };
in
{
  simple = simple "simple" false;
  simple-socketActivated = simple "simple-socketActivated" true;
  deprecated = makeTest {
    name = "rspamd-deprecated";
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
      $machine->fail("systemctl cat rspamd-normal-1.socket");
      $machine->log($machine->succeed("rspamc -h /run/rspamd-worker.sock stat"));
      $machine->log($machine->succeed("curl --unix-socket /run/rspamd-worker.sock http://localhost/ping"));
    '';
  };

  bindports = makeTest {
    name = "rspamd-bindports";
    machine = {
      services.rspamd = {
        enable = true;
        socketActivation = false;
        workers.normal.bindSockets = [{
          socket = "/run/rspamd.sock";
          mode = "0600";
          owner = "root";
          group = "root";
        }];
        workers.controller.bindSockets = [{
          socket = "/run/rspamd-worker.sock";
          mode = "0666";
          owner = "root";
          group = "root";
        }];
      };
    };

    testScript = ''
      ${initMachine}
      $machine->waitForFile("/run/rspamd.sock");
      ${checkSocket "/run/rspamd.sock" "root" "root" "600" }
      ${checkSocket "/run/rspamd-worker.sock" "root" "root" "666" }
      $machine->fail("systemctl cat rspamd-normal-1.socket");
      $machine->log($machine->succeed("rspamc -h /run/rspamd-worker.sock stat"));
      $machine->log($machine->succeed("curl --unix-socket /run/rspamd-worker.sock http://localhost/ping"));
    '';
  };
  socketActivated = makeTest {
    name = "rspamd-socketActivated";
    machine = {
      services.rspamd = {
        enable = true;
        workers.normal.bindSockets = [{
          socket = "/run/rspamd.sock";
          mode = "0600";
          owner = "root";
          group = "root";
        }];
        workers.controller.bindSockets = [{
          socket = "/run/rspamd-worker.sock";
          mode = "0666";
          owner = "root";
          group = "root";
        }];
      };
    };

    testScript = ''
      startAll
      $machine->waitForFile("/run/rspamd.sock");
      ${checkSocket "/run/rspamd.sock" "root" "root" "600" }
      ${checkSocket "/run/rspamd-worker.sock" "root" "root" "666" }
      $machine->log($machine->succeed("systemctl cat rspamd-normal-1.socket"));
      $machine->log($machine->succeed("rspamc -h /run/rspamd-worker.sock stat"));
      $machine->log($machine->succeed("curl --unix-socket /run/rspamd-worker.sock http://localhost/ping"));
    '';
  };
}
