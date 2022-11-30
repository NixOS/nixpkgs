# Note that these schemas are defined by RFC-0125.
# This document is considered a stable API, and is depended upon by external tooling.
# Changes to the structure of the document, or the semantics of the values should go through an RFC.
#
# See: https://github.com/NixOS/rfcs/pull/125
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.boot.bootspec;
  children = lib.mapAttrs (childName: childConfig: childConfig.configuration.system.build.toplevel) config.specialisation;
  schemas = {
    v1 = rec {
      filename = "boot.json";
      json =
        pkgs.writeText filename
          (builtins.toJSON
          {
            v1 = {
              kernel = "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}";
              kernelParams = config.boot.kernelParams;
              initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
              initrdSecrets = "${config.system.build.initialRamdiskSecretAppender}/bin/append-initrd-secrets";
              label = "NixOS ${config.system.nixos.codeName} ${config.system.nixos.label} (Linux ${config.boot.kernelPackages.kernel.modDirVersion})";

              inherit (cfg) extensions;
            };
          });

      generator =
        let
          specialisationLoader = (lib.mapAttrsToList
            (childName: childToplevel: lib.escapeShellArgs [ "--slurpfile" childName "${childToplevel}/bootspec/${filename}" ])
            children);
        in
        ''
          mkdir -p $out/bootspec

          # Inject toplevel and init in the bootspec.
          # This can be done only here because we *cannot* depend on $out, except
          # by living in $out itself.
          ${pkgs.jq}/bin/jq '
            .v1.toplevel = $toplevel |
            .v1.init = $init
            ' \
            --sort-keys \
            --arg toplevel "$out" \
            --arg init "$out/init" \
            < ${json} \
            | ${pkgs.jq}/bin/jq \
              --sort-keys \ # Slurp all specialisations and inject them as values in .specialisations.{name} = {specialisation bootspec}.
              '.v1.specialisation = ($ARGS.named | map_values(. | first | .v1))' \
              ${lib.concatStringsSep " " specialisationLoader} \
            > $out/bootspec/${filename}
        '';

      validator = pkgs.writeCueValidator ./bootspec.cue {
        document = "Document"; # Universal validator for any version as long the schema is correctly set.
      };
    };
  };
in
{
  options.boot.bootspec = {
    enable = lib.mkEnableOption "Enable generation of RFC-0125 bootspec in $system/bootspec, e.g. /run/current-system/bootspec";
    extensions = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
    # This will be run as a part of the `systemBuilder` in ./top-level.nix. This
    # means `$out` points to the output of `config.system.build.toplevel` and can
    # be used for a variety of things (though, for now, it's only used to report
    # the path of the `toplevel` itself and the `init` executable).
    writer = lib.mkOption {
      internal = true;
      default = schemas.v1.generator;
    };
    validator = lib.mkOption {
      internal = true;
      default = schemas.v1.validator;
    };
    filename = lib.mkOption {
      internal = true;
      default = schemas.v1.filename;
    };
  };

  config = lib.mkIf (cfg.enable) {
    warnings = [
      ''RFC-0125 is not merged yet, this is a feature preview of bootspec.
        The schema is not definitive and features are not guaranteed to be stable until RFC-0125 is merged.
        See:
        - https://github.com/NixOS/nixpkgs/pull/172237 to track merge status in nixpkgs.
        - https://github.com/NixOS/rfcs/pull/125 to track RFC status.
      ''
    ];
  };
}
