{ lib, pkgs, ... }:
{
  name = "nix-daemon-unprivileged";
  meta.maintainers = with lib.maintainers; [ artemist ];

  nodes.machine = {
    users.groups.nix-daemon = { };
    users.users.nix-daemon = {
      isSystemUser = true;
      group = "nix-daemon";
    };

    nix = {
      package = pkgs.nixVersions.git;
      daemonUser = "nix-daemon";
      daemonGroup = "nix-daemon";
      settings.experimental-features = [
        "local-overlay-store"
        "auto-allocate-uids"
      ];
    };

    # Easiest way to get a file onto the machine
    environment.etc."test.nix".text = ''
      derivation {
        name = "test";
        builder = "/bin/sh";
        args = [ "-c" "echo succeeded > $out" ];
        system = "${pkgs.stdenv.hostPlatform.system}";
      }
    '';
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("sockets.target")
    machine.succeed("NIX_REMOTE=daemon nix-build /etc/test.nix")
  '';
}
