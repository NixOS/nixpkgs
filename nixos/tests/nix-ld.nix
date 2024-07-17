{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:
let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  shared =
    { config, pkgs, ... }:
    {
      programs.nix-ld.enable = true;
      environment.systemPackages = [
        (pkgs.runCommand "patched-hello" { } ''
          install -D -m755 ${pkgs.hello}/bin/hello $out/bin/hello
          patchelf $out/bin/hello --set-interpreter $(cat ${config.programs.nix-ld.package}/nix-support/ldpath)
        '')
      ];
    };
in
{
  nix-ld = makeTest {
    name = "nix-ld";
    nodes.machine = shared;
    testScript = ''
      start_all()
      machine.succeed("hello")
    '';
  };
  nix-ld-rs = makeTest {
    name = "nix-ld-rs";
    nodes.machine = {
      imports = [ shared ];
      programs.nix-ld.package = pkgs.nix-ld-rs;
    };
    testScript = ''
      start_all()
      machine.succeed("hello")
    '';
  };
}
