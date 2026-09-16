# Evaluation test for the system.initSystem toggle.
# Verifies that
#   - the default (systemd) translates system.services exactly like before,
#   - switching to dinit/runit/s6 swaps the backend and no systemd units are
#     generated for modular services,
#   - the toggle does not affect existing options (systemd.* remains usable).
#
# Run (from the nixpkgs checkout):
#   nix-instantiate --eval --strict --impure --argstr rootDir "$PWD" \
#     nixos/modules/system/service/init-system-eval-check.nix
{ rootDir }:

let
  root = rootDir;
  evalConfig = import (root + "/nixos/lib/eval-config.nix");

  baseServices = {
    system.services.web = {
      process = {
        argv = [ "/bin/web" ];
        type = "oneshot";
      };
      dependencies.after = [ "db" ];
      runtime.user = "nobody";
    };
    system.services.db = {
      process.argv = [ "/bin/db" ];
    };
  };

  machine = initSystem: (evalConfig {
    system = "x86_64-linux";
    modules = [
      baseServices
      {
        system.initSystem = initSystem;
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

  default = machine "systemd";
  dinit = machine "dinit";
  runit = machine "runit";
  s6 = machine "s6";
  rcD = machine "rc.d";
  dinitCompat = (import (root + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      baseServices
      {
        system.initSystem = "dinit";
        system.systemdCompatibility.enable = true;
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
# default: systemd backend, exactly as before
assert default.systemd.units ? "web.service";
assert builtins.match ".*After=db.service.*" default.systemd.units."web.service".text != null;
assert !(default.environment.etc ? "dinit.d/web");
assert !(default.environment.etc ? "runit/services/web/run");

# dinit
assert dinit.environment.etc ? "dinit.d/web";
assert builtins.match ".*after: db.*" dinit.environment.etc."dinit.d/web".text != null;
assert !(dinit.systemd.units ? "web.service");
# existing options still work
assert dinit.systemd.services ? systemd-udevd;

# runit
assert runit.environment.etc ? "runit/services/web/run";
assert runit.environment.etc ? "runit/services/web/down";
assert runit.system.build.runitBootScript.outPath != "";
assert !(runit.systemd.units ? "web.service");

# s6
assert s6.system.build.s6Services.outPath != "";
assert s6.system.build.s6RcDb.outPath != "";
assert !(s6.systemd.units ? "web.service");

# rc.d
assert rcD.environment.etc ? "rc.d/web";
assert builtins.match ".*# PROVIDE: web.*" rcD.environment.etc."rc.d/web".text != null;
assert builtins.match ".*# REQUIRE: db.*" rcD.environment.etc."rc.d/web".text != null;
assert builtins.match ".*command_user=\"nobody\".*" rcD.environment.etc."rc.d/web".text != null;
assert rcD.environment.etc ? "rc.conf.d/web";
assert rcD.environment.etc."rc.conf.d/web".text == "web_enable=\"YES\"\n";
assert rcD.system.build.freebsdRcScripts.outPath != "";
assert !(rcD.systemd.units ? "web.service");

# systemd compatibility layer (opt-in) with a non-systemd backend
assert dinitCompat.system.build.systemdCompatibilityLayer.outPath != "";
assert dinitCompat.environment.systemPackages != [ ];
assert dinitCompat.environment.etc ? "dinit.d/systemd-compat";
assert builtins.match ".*systemd-compat-dbus.*" dinitCompat.environment.etc."dinit.d/systemd-compat".text != null;

"ok"