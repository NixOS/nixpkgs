# Regression test for the `pythonTestDriverPackage` option's default value
# leaking a `hostPkgs` reference into the NixOS manual build.
#
# `pythonTestDriverPackage` (added in d95261b435c4, "nixos-test-driver: Make
# overridable") uses `default = hostPkgs.nixos-test-driver`. Without a
# `defaultText`, the options-doc renderer force-evaluates that default when
# building `options.json` for the NixOS manual. `hostPkgs` is only defined in
# the VM testing framework, so evaluating its default from a regular NixOS
# system configuration throws:
#
#   error: The option `hostPkgs' was accessed but has no value defined.
#
# In practice the bug only surfaces when `pkgs` ends up depending on
# `config` — e.g. when `nixpkgs.config.packageOverrides` is wrapped in
# `lib.mkIf`. Otherwise `nixos/doc/manual/default.nix`'s fallback
# `config.hostPkgs = pkgs` rescue holds. With the dependency, that rescue
# creates a cycle and the original `hostPkgs` error surfaces.
#
# The test builds a minimal system whose `pkgs` depends on `config`, and
# asserts the toplevel (which includes `nixos-manual-html`) evaluates.

{
  pkgs,
  ...
}:
let
  evalConfig = import ../../lib/eval-config.nix;

  nixos = evalConfig {
    system = null;
    modules = [
      (
        { lib, ... }:
        {
          system.stateVersion = "25.05";
          fileSystems."/" = {
            device = "/dev/null";
            fsType = "none";
          };
          boot.loader.grub.device = "nodev";
          nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;

          # This is the trigger: wrapping `packageOverrides` in `mkIf` makes
          # the `pkgs` module argument depend on `config`, which defeats the
          # `config.hostPkgs = pkgs` rescue in `nixos/doc/manual/default.nix`.
          nixpkgs.config.packageOverrides = lib.mkIf false (_: { });
        }
      )
    ];
  };
in
pkgs.runCommand "nixos-test-driver-options-doc-regression"
  {
    toplevel = nixos.config.system.build.toplevel.drvPath;
  }
  ''
    echo "$toplevel" > $out
  ''
