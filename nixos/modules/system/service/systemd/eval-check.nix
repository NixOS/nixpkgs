# Fast evaluation test for the modular service systemd integration.
# Forces the generated systemd unit texts through the full NixOS module set
# and asserts the abstract service options are translated correctly.
#
# Run (from the nixpkgs checkout):
#   nix-instantiate --eval --strict --impure --argstr rootDir "$PWD" \
#     nixos/modules/system/service/systemd/eval-check.nix
{ rootDir }:

let
  root = rootDir;
  machine = (import (root + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      {
        system.services.web = {
          process.argv = [ "/bin/web" ];
          dependencies.after = [ "db" ];
          runtime = {
            user = "nobody";
            workingDirectory = "/var/lib/web";
          };
          environment.FOO = "bar";
          process.type = "oneshot";
          restart = {
            policy = "on-failure";
            delay = 3;
          };
        };
        system.services.web.services.api = {
          process.argv = [ "/bin/api" ];
          dependencies.after = [ "log" ];
        };
        system.services.web.services.log = {
          process.argv = [ "/bin/log" ];
        };
        system.services.db = {
          process.argv = [ "/bin/db" ];
        };
        system.services.disabled = {
          enable = false;
          process.argv = [ "/bin/nope" ];
          services.sub = {
            process.argv = [ "/bin/nope-sub" ];
          };
        };

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
assert machine.systemd.units ? "web.service";
assert machine.systemd.units ? "db.service";
# abstract dependencies -> unit ordering, resolved against the parent level
assert builtins.match ".*After=db.service.*" machine.systemd.units."web.service".text != null;
# nested sibling dependency resolves to the absolute unit name
assert builtins.match ".*After=web-log.service.*" machine.systemd.units."web-api.service".text != null;
# runtime context
assert builtins.match ".*User=nobody.*" machine.systemd.units."web.service".text != null;
assert builtins.match ".*Group=nobody.*" machine.systemd.units."web.service".text != null;
assert builtins.match ".*WorkingDirectory=/var/lib/web.*" machine.systemd.units."web.service".text != null;
# environment
assert builtins.match ".*Environment=FOO=bar.*" machine.systemd.units."web.service".text != null;
# lifecycle
assert builtins.match ".*Type=oneshot.*" machine.systemd.units."web.service".text != null;
assert builtins.match ".*RemainAfterExit=true.*" machine.systemd.units."web.service".text != null;
# restart policy
assert builtins.match ".*Restart=on-failure.*" machine.systemd.units."web.service".text != null;
assert builtins.match ".*RestartSec=3.*" machine.systemd.units."web.service".text != null;
# defaults for unset options
assert builtins.match ".*Type=simple.*" machine.systemd.units."db.service".text != null;
assert builtins.match ".*Restart=always.*" machine.systemd.units."db.service".text != null;
# disabled services generate no units, including their sub-services
assert !(machine.systemd.units ? "disabled.service");
assert !(machine.systemd.units ? "disabled-sub.service");
"ok"