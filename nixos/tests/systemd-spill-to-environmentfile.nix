# Test that long environment variables spill over into an
# EnvironmentFile.
import ./make-test.nix ({ pkgs, ...} : {
  name = "systemd-spill-to-environmentfile";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ teh ];
  };

  machine = { config, pkgs, lib, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
    systemd.services.long-env-unit = {
      wantedBy = [ "multi-user.target" ];
      script = "true";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      environment = {
        SHORTVAR = "shortvar";
        # exacly 1 MiB long
        LONGVAR = lib.concatStrings (builtins.map (x: "longvar.") (lib.range 1 256));
      };
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("long-env-unit.service");
      $machine->shutdown;
    '';
})
