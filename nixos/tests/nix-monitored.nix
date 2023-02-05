import ./make-test-python.nix ({ lib, pkgs, ... }:
  let nix-monitored = attrs: pkgs.nix-monitored.override attrs; in
  {
    name = "nix-monitored";
    nodes.withNotify = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ expect ];
      nix.monitored.enable = true;
      nix.monitored.notify = true;
    };
    nodes.withoutNotify = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ expect ];
      nix.monitored.enable = true;
    };
    testScript = ''
      start_all()

      machines = [withNotify, withoutNotify]
      packages = ["${nix-monitored { withNotify = true; }}", "${nix-monitored { withNotify = false; }}"]

      for (machine, package) in zip(machines, packages):
        for binary in ["nix", "nix-build", "nix-shell"]:
          actual = machine.succeed(f"readlink $(which {binary})")
          expected = f"{package}/bin/{binary}"
          assert expected == actual.strip(), f"{binary} binary is {actual}, expected {expected}"

        actual = machine.succeed("unbuffer nix --version")
        expected = "nix-output-monitor ${pkgs.nix-output-monitor.version}\nnix (Nix) ${pkgs.nix.version}"
        assert expected == actual.strip(), f"version string is {actual}, expected {expected}"

        actual = machine.succeed("which -a nix")
        expected = "/run/current-system/sw/bin/nix\n${pkgs.nix}/bin/nix"
        assert expected == actual.strip(), f"nix paths are {actual}, expected {expected}"
    '';
  })
