{ ... }: {
  name = "lix";

  nodes.machine = { pkgs, ... }: {
    nix.package = pkgs.lix;

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
