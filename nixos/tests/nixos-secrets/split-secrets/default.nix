{
  name = "nixos-secrets-split-secrets";

  nodes.machine =
    { pkgs, ... }:
    {
      nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
      environment.etc."nixos".source = ./config;

      environment.systemPackages = [ pkgs.nixos-secrets ];
      nix.enable = true;

      system.extraDependencies = [
        (import ../collect-secrets-scripts.nix {
          inherit pkgs;
          configuration = ./config;
        })
      ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("nixos-secrets generate -f /etc/nixos")
    machine.succeed("test -f /tmp/secrets/plain/generators/ssh-split/files/ed25519.key.pub")
    machine.succeed("test -f /tmp/secrets/age/generators/ssh-split/files/ed25519.key")
    machine.succeed("test -f /tmp/secrets/age/generators/ssh-split/files/.nixos-secrets-metadata")
  '';
}
