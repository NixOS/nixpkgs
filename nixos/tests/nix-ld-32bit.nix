{ ... }:
{
  name = "nix-ld-32bit";

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
}
