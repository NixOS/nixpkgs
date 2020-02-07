import ../make-test-python.nix {
  machine = { pkgs, ... }: {
    imports = [ ../../modules/profiles/minimal.nix ];
    environment.systemPackages = [ pkgs.lorri ];
  };

  testScript = ''
    # Copy files over
    machine.succeed(
        "cp '${./fake-shell.nix}' shell.nix"
    )
    machine.succeed(
        "cp '${./builder.sh}' builder.sh"
    )

    # Start the daemon and wait until it is ready
    machine.execute("lorri daemon > lorri.stdout 2> lorri.stderr &")
    machine.wait_until_succeeds("grep --fixed-strings 'ready' lorri.stdout")

    # Ping the daemon
    machine.succeed("lorri internal__ping shell.nix")

    # Wait for the daemon to finish the build
    machine.wait_until_succeeds("grep --fixed-strings 'Completed' lorri.stdout")
  '';
}
