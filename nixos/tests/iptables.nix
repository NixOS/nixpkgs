import ./make-test-python.nix ({ pkgs, ... }:
let
  inherit (pkgs) iptables python310;
in
{
  name = "iptables";

  machine = { ... }: { };

  testScript = ''
    machine.succeed("cp -r ${iptables.src} ~/src")
    machine.succeed("cd ~/src && ${python310}/bin/python ~/src/iptables-test.py")
  '';
})
