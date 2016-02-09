{ config, options, lib, ... }:

# This modules is used to inject a different NixOS version as well as its
# argument such that one can pin a specific version with the versionning
# system of the configuration.
let
  nixosReentry = import config.nixos.path {
    inherit (config.nixos) configuration extraModules;
    inherit (config.nixpkgs) system;
    reEnter = true;
  };
in

with lib;

{
  options = {
    nixos.path = mkOption {
      default = null;
      example = literalExample "./nixpkgs-15.09/nixos";
      type = types.nullOr types.path;
      description = ''
        This option give the ability to evaluate the current set of modules
        with a different version of NixOS. This option can be used version
        the version of NixOS with the configuration without relying on the
        <literal>NIX_PATH</literal> environment variable.
      '';
    };

    nixos.system = mkOption {
      example = "i686-linux";
      type = types.uniq types.str;
      description = ''
        Name of the system used to compile NixOS.
      '';
    };

    nixos.extraModules = mkOption {
      default = [];
      example = literalExample "[ ./sshd-config.nix ]";
      type = types.listOf (types.either (types.submodule ({...}:{options={};})) types.path);
      description = ''
        Define additional modules which would be loaded to evaluate the
        configuration.
      '';
    };

    nixos.configuration = mkOption {
      type = types.unspecified;
      internal = true;
      description = ''
        Option used by <filename>nixos/default.nix</filename> to re-inject
        the same configuration module as the one used for the current
        execution.
      '';
    };

    nixos.reflect = mkOption {
      default = { inherit config options; };
      type = types.unspecified;
      internal = true;
      description = ''
        Provides <literal>config</literal> and <literal>options</literal>
        computed by the module system and given as argument to all
        modules. These are used for introspection of options and
        configuration by tools such as <literal>nixos-option</literal>.
      '';
    };
  };

  config = mkMerge [
    (mkIf (config.nixos.path != null) (mkForce {
      system.build.toplevel = nixosReentry.system;
      system.build.vm = nixosReentry.vm;
      nixos.reflect = { inherit (nixosReentry) config options; };
    }))

    { meta.maintainers = singleton lib.maintainers.pierron;
      meta.doc = ./nixos.xml;
    }
  ];
}
