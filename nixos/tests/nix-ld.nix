{ ... }:
{
  name = "nix-ld";

  nodes.machine =
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

  testScript = ''
    start_all()
    machine.succeed("hello")
  '';
}
