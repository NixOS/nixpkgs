# Checks executados por `nix flake check`.
#
# Cada pacote é o próprio check (build completo). O artefato WASM fica de fora
# porque depende de uma toolchain com std para `wasm32-unknown-unknown`.
{ pkgs, packages }:

let
  inherit (pkgs) lib;

  moduleConfig = (import (pkgs.path + "/nixos/lib/eval-config.nix") {
    system = pkgs.stdenv.hostPlatform.system;
    modules = [
      ../modules/arkhe-node.nix
      ../modules/arkhe-audit.nix
      {
        services.arkheNode = { enable = true; package = pkgs.hello; environmentFile = "/run/secrets/arkhe.env"; };
        services.arkheAudit = { enable = true; package = pkgs.hello; };
        system.stateVersion = "26.05";
      }
    ];
  }).config;

  checkable = lib.filterAttrs (
    name: value: lib.isDerivation value && name != "arkhe-verify-wasm"
  ) packages;
in
checkable
// {
  modules = assert moduleConfig.systemd.services.arkhe-runtime.serviceConfig.EnvironmentFile == "/run/secrets/arkhe.env";
    assert builtins.length moduleConfig.environment.systemPackages >= 1;
    pkgs.runCommand "arkhe-modules-eval" { } "touch $out";

  smoke = pkgs.runCommand "arkhe-verify-smoke" { } ''
    mkdir -p $out
    ${packages.arkhe-verify}/bin/arkhe-verify --help > $out/help.txt
  '';
}
