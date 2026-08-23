{ ... }: {
  name = "nix-local-store";

  nodes.machine = { pkgs, ... }: {
    nix.daemon.enable = false;
    nix.settings = {
      experimental-features = [ "nix-command" ];
      log-lines = 26;
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
    machine.succeed("nix-build /etc/test.nix")
    log_lines = machine.succeed("nix config show log-lines").strip()
    assert int(log_lines) == 26, "Nix settings not respected by local store"
  '';
}
