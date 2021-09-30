import ./make-test-python.nix ({ pkgs, ... }:
let
  inherit (pkgs) iptables python3;
in
{
  name = "iptables";

  machine = { ... }: { };

  testScript = ''
    machine.succeed("cp -r ${iptables.src} ~/src")
    machine.succeed("cd ~/src && ${python3}/bin/python ~/src/iptables-test.py")
  '';
})
