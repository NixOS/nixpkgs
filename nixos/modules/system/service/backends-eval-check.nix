# Fast evaluation test for the dinit, runit and s6 modular service backends.
# Forces the generated backend configuration and asserts the abstract service
# options are translated correctly for each backend.
#
# Run (from the nixpkgs checkout):
#   nix-instantiate --eval --strict --impure --argstr rootDir "$PWD" \
#     nixos/modules/system/service/backends-eval-check.nix
{ rootDir }:

let
  root = rootDir;
  nixosLib = import (root + "/nixos/lib") { };
  lib = import (root + "/lib");
  pkgs = import (root + "/pkgs/top-level") {
    inherit lib;
    localSystem = {
      system = "x86_64-linux";
    };
    config = { };
    overlays = [ ];
  };

  testServices = {
    web = {
      process = {
        argv = [ "/bin/web" ];
        type = "oneshot";
      };
      dependencies.after = [ "db" ];
      runtime = {
        user = "nobody";
        group = "nogroup";
        workingDirectory = "/var/lib/web";
      };
      environment.FOO = "bar";
      restart = {
        policy = "on-failure";
        delay = 3;
      };
      configData."web.conf" = {
        text = "port=8080";
      };
    };
    web.services.api = {
      process.argv = [ "/bin/api" ];
      # sibling dependency inside the web sub-tree
      dependencies.after = [ "log" ];
    };
    web.services.log = {
      process.argv = [ "/bin/log" ];
    };
    db = {
      process = {
        argv = [ "/bin/db" ];
        type = "notify";
        stopSignal = "HUP";
        startTimeout = 10;
        stopTimeout = 20;
      };
      notificationProtocol.s6 = true;
      dependencies = {
        requires = [ "net" ];
        wants = [ "dbg" ];
      };
    };
    net = {
      process.argv = [ "/bin/net" ];
      restart.policy = "never";
    };
    dbg = {
      process.argv = [ "/bin/dbg" ];
    };
    disabled = {
      enable = false;
      process.argv = [ "/bin/nope" ];
      services.sub = {
        process.argv = [ "/bin/nope-sub" ];
      };
    };
  };

  evalConfig = import (root + "/nixos/lib/eval-config.nix");

  evalBackend = be: (evalConfig {
    system = "x86_64-linux";
    modules = [
      {
        system.initSystem = be;
        system.services = testServices;
        # irrelevant stuff
        system.stateVersion = "25.05";
        fileSystems."/" = {
          device = "/test/dummy";
          fsType = "auto";
        };
        boot.loader.grub.enable = false;
      }
    ];
  }).config;
in
let
  dinit = evalBackend "dinit";
  runit = evalBackend "runit";
  s6 = evalBackend "s6";
in
assert builtins.match ".*type = scripted.*" dinit.environment.etc."dinit.d/web".text != null;
assert builtins.match ".*restart = on-failure.*" dinit.environment.etc."dinit.d/web".text != null;
assert builtins.match ".*after: db.*" dinit.environment.etc."dinit.d/web".text != null;
assert builtins.match ".*working-dir = /var/lib/web.*" dinit.environment.etc."dinit.d/web".text != null;
assert builtins.match ".*env = FOO=bar.*" dinit.environment.etc."dinit.d/web".text != null;
# non-root user -> setpriv wrapper is deployed and referenced
assert dinit.environment.etc ? "dinit.d/scripts/web";
assert builtins.match ".*command = /etc/dinit.d/scripts/web.*" dinit.environment.etc."dinit.d/web".text != null;
# nested sibling dependency resolves to the absolute name
assert builtins.match ".*after: web-log.*" dinit.environment.etc."dinit.d/web-api".text != null;
# lifecycle + restart + signals
assert builtins.match ".*restart = false.*" dinit.environment.etc."dinit.d/net".text != null;
assert builtins.match ".*restart = true.*" dinit.environment.etc."dinit.d/db".text != null;
assert builtins.match ".*term-signal = HUP.*" dinit.environment.etc."dinit.d/db".text != null;
assert builtins.match ".*start-timeout = 10.*" dinit.environment.etc."dinit.d/db".text != null;
assert builtins.match ".*stop-timeout = 20.*" dinit.environment.etc."dinit.d/db".text != null;
assert builtins.match ".*ready-notification = pipefd:4.*" dinit.environment.etc."dinit.d/db".text != null;
assert builtins.match ".*depends-on: net.*" dinit.environment.etc."dinit.d/db".text != null;
assert builtins.match ".*waits-for: dbg.*" dinit.environment.etc."dinit.d/db".text != null;
# configData lands under the backend's config directory
assert dinit.environment.etc ? "dinit/system-services/web/web.conf";

# runit
# oneshot: single exec (via chpst for the nobody user), no restart loop
assert builtins.match ".*chpst -u nobody /bin/web.*" runit.environment.etc."runit/services/web/run".text != null;
assert builtins.match ".*while true.*" runit.environment.etc."runit/services/web/run".text == null;
# simple + always: supervised loop with restart delay
assert builtins.match ".*while true; do.*" runit.environment.etc."runit/services/db/run".text != null;
assert builtins.match ".*exec /bin/db.*" runit.environment.etc."runit/services/db/run".text != null;
assert builtins.match ".*sleep 5.*" runit.environment.etc."runit/services/db/run".text != null;
# never: single exec, no loop
assert builtins.match ".*exec /bin/net.*" runit.environment.etc."runit/services/net/run".text != null;
assert builtins.match ".*while true.*" runit.environment.etc."runit/services/net/run".text == null;
assert runit.environment.etc ? "runit/services/web/down";
assert runit.system.build.runitBootScript.outPath != "";
assert runit.system.build.runitBootOrder == [
  "dbg"
  "net"
  "db"
  "web"
  "web-log"
  "web-api"
];
# disabled services generate nothing
assert !(runit.environment.etc ? "runit/services/disabled");
assert !(runit.environment.etc ? "runit/services/disabled-sub");
assert !(dinit.environment.etc ? "dinit.d/disabled");
assert !(dinit.environment.etc ? "dinit.d/disabled-sub");
assert !(s6.environment.etc ? "s6/services/disabled");

# s6
assert s6.system.build.s6Services.outPath != "";
assert s6.system.build.s6RcDb.outPath != "";
assert s6.environment.etc ? "s6/system-services/web/web.conf";
"ok"