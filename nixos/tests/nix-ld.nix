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
  nix-ld-32 = makeTest {
    name = "nix-ld-32";
    nodes.machine = {
      imports = [
        (
          { config, pkgs, ... }:
          let
            system = "i686-linux";
            inherit (config.programs.nix-ld.systems.${system}) package;
          in
          {
            programs.nix-ld.systems.i686-linux.ldso = "ldso32";
            programs.nix-ld.systems.i686-linux.pkgs = pkgs.pkgsi686Linux;
            environment.systemPackages = [
              (pkgs.runCommand "patched-hello" { } ''
                install -D -m755 ${pkgs.pkgsi686Linux.hello}/bin/hello $out/bin/hello
                patchelf $out/bin/hello --set-interpreter $(cat ${package}/nix-support/ldpath)
              '')
            ];
          }
        )
      ];
    };
    testScript = ''
      start_all()
      machine.succeed("hello")
    '';
  };
}
