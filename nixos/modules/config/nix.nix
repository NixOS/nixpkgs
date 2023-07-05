/*
  Manages /etc/nix.conf, build machines and any nix-specific global config files.
 */
{ config, lib, pkgs, ... }:

let
  inherit (lib)
    concatStringsSep
    boolToString
    escape
    floatToString
    getVersion
    isBool
    isDerivation
    isFloat
    isInt
    isList
    isString
    mapAttrsToList
    mkIf
    mkRenamedOptionModuleWith
    optionalString
    strings
    toPretty
    versionAtLeast
    ;

  cfg = config.nix;

  nixPackage = cfg.package.out;

  isNixAtLeast = versionAtLeast (getVersion nixPackage);

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

  nixConf =
    assert isNixAtLeast "2.2";
    let

      mkValueString = v:
        if v == null then ""
        else if isInt v then toString v
        else if isBool v then boolToString v
        else if isFloat v then floatToString v
        else if isList v then toString v
        else if isDerivation v then toString v
        else if builtins.isPath v then toString v
        else if isString v then v
        else if strings.isConvertibleWithToString v then toString v
        else abort "The nix conf value: ${toPretty {} v} can not be encoded";

      mkKeyValue = k: v: "${escape [ "=" ] k} = ${mkValueString v}";

      mkKeyValuePairs = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValue attrs);

    in
    pkgs.writeTextFile {
      name = "nix.conf";
      text = ''
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        ${mkKeyValuePairs cfg.settings}
        ${cfg.extraOptions}
      '';
      checkPhase = lib.optionalString cfg.checkConfig (
        if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then ''
          echo "Ignoring validation for cross-compilation"
        ''
        else ''
          echo "Validating generated nix.conf"
          ln -s $out ./nix.conf
          set -e
          set +o pipefail
          NIX_CONF_DIR=$PWD \
            ${cfg.package}/bin/nix show-config ${optionalString (isNixAtLeast "2.3pre") "--no-net"} \
              ${optionalString (isNixAtLeast "2.4pre") "--option experimental-features nix-command"} \
            |& sed -e 's/^warning:/error:/' \
            | (! grep '${if cfg.checkAllErrors then "^error:" else "^error: unknown setting"}')
          set -o pipefail
        '');
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

  config = mkIf cfg.enable {
    environment.etc."nix/nix.conf".source = nixConf;
  };
}
