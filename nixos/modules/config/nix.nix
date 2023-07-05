/*
  Manages /etc/nix.conf, build machines and any nix-specific global config files.
 */
{ config, lib, pkgs, ... }:

let

  cfg = config.nix;

  inherit (lib)
    mapAttrsToList
    mkRenamedOptionModuleWith
    ;

  legacyConfMappings = {
    useSandbox = "sandbox";
    buildCores = "cores";
    maxJobs = "max-jobs";
    sandboxPaths = "extra-sandbox-paths";
    binaryCaches = "substituters";
    trustedBinaryCaches = "trusted-substituters";
    binaryCachePublicKeys = "trusted-public-keys";
    autoOptimiseStore = "auto-optimise-store";
    requireSignedBinaryCaches = "require-sigs";
    trustedUsers = "trusted-users";
    allowedUsers = "allowed-users";
    systemFeatures = "system-features";
  };

in
{
  imports =
    mapAttrsToList
      (oldConf: newConf:
        mkRenamedOptionModuleWith {
          sinceRelease = 2205;
          from = [ "nix" oldConf ];
          to = [ "nix" "settings" newConf ];
      })
      legacyConfMappings;

}
