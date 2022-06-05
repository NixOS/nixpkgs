{ evalMinimalConfig, pkgs, lib, stdenv }:
lib.recurseIntoAttrs {
  invokeNixpkgsSimple =
    (evalMinimalConfig ({ config, modulesPath, ... }: {
      imports = [ (modulesPath + "/misc/nixpkgs.nix") ];
      nixpkgs.system = stdenv.hostPlatform.system;
    }))._module.args.pkgs.hello;
}
