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
              system = config.boot.kernelPackages.stdenv.hostPlatform.system;
              kernel = "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}";
              kernelParams = config.boot.kernelParams;
              label = "${config.system.nixos.distroName} ${config.system.nixos.codeName} ${config.system.nixos.label} (Linux ${config.boot.kernelPackages.kernel.modDirVersion})";

              inherit (cfg) extensions;
            } // lib.optionalAttrs config.boot.initrd.enable {
              initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
              initrdSecrets = "${config.system.build.initialRamdiskSecretAppender}/bin/append-initrd-secrets";
            };
          });

      generator =
        let
          # NOTE: Be careful to not introduce excess newlines at the end of the
          # injectors, as that may affect the pipes and redirects.

          # Inject toplevel and init into the bootspec.
          # This can only be done here because we *cannot* depend on $out
          # referring to the toplevel, except by living in the toplevel itself.
          toplevelInjector = lib.escapeShellArgs [
            "${pkgs.jq}/bin/jq"
            ''
              .v1.toplevel = $toplevel |
              .v1.init = $init
            ''
            "--sort-keys"
            "--arg" "toplevel" "${placeholder "out"}"
            "--arg" "init" "${placeholder "out"}/init"
          ] + " < ${json}";

          # We slurp all specialisations and inject them as values, such that
          # `.specialisations.${name}` embeds the specialisation's bootspec
          # document.
          specialisationInjector =
            let
              specialisationLoader = (lib.mapAttrsToList
                (childName: childToplevel: lib.escapeShellArgs [ "--slurpfile" childName "${childToplevel}/${filename}" ])
                children);
            in
            lib.escapeShellArgs [
              "${pkgs.jq}/bin/jq"
              "--sort-keys"
              ".v1.specialisation = ($ARGS.named | map_values(. | first | .v1))"
            ] + " ${lib.concatStringsSep " " specialisationLoader}";
        in
        ''
          mkdir -p $out/bootspec

          ${toplevelInjector} | ${specialisationInjector} > $out/${filename}
        '';

      validator = pkgs.writeCueValidator ./bootspec.cue {
        document = "Document"; # Universal validator for any version as long the schema is correctly set.
      };
    };
  };
in
{
  options.boot.bootspec = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable generation of RFC-0125 bootspec in $system/bootspec, e.g. /run/current-system/bootspec");

    extensions = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # <namespace>: { ...namespace-specific fields }
      default = { };
      description = lib.mdDoc ''
        User-defined data that extends the bootspec document.

        To reduce incompatibility and prevent names from clashing
        between applications, it is **highly recommended** to use a
        unique namespace for your extensions.
      '';
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
