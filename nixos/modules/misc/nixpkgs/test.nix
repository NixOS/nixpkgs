{ lib, stdenv }:
lib.recurseIntoAttrs {
  invokeNixpkgsSimple =
    (lib.nixos.core ({ config, modules, ... }: {
      imports = [ modules.invokeNixpkgs ];
      nixpkgs.system = stdenv.hostPlatform.system;
    }))._module.args.pkgs.hello;
}
