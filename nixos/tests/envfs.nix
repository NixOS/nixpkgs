{ lib, pkgs, ... }:
let
  pythonShebang = pkgs.writeScript "python-shebang" ''
    #!/usr/bin/python
    print("OK")
  '';

  bashShebang = pkgs.writeScript "bash-shebang" ''
    #!/usr/bin/bash
    echo "OK"
  '';
in
{
  name = "envfs";
  nodes.machine.services.envfs.enable = true;

  testScript = ''
    start_all()
    machine.wait_until_succeeds("mountpoint -q /usr/bin/")
    machine.succeed(
        "PATH=${pkgs.coreutils}/bin /usr/bin/cp --version",
        # check fallback paths
        "PATH= /usr/bin/sh --version",
        "PATH= /usr/bin/env --version",
        "PATH= test -e /usr/bin/sh",
        "PATH= test -e /usr/bin/env",
        # also picks up PATH that was set after execve
        "! /usr/bin/hello",
        "PATH=${pkgs.hello}/bin /usr/bin/hello",
    )

    out = machine.succeed("PATH=${pkgs.python3}/bin ${pythonShebang}")
    print(out)
    assert out == "OK\n"

    out = machine.succeed("PATH=${pkgs.bash}/bin ${bashShebang}")
    print(out)
    assert out == "OK\n"
  '';
}
