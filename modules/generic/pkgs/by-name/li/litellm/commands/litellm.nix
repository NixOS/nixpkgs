# Command line of `litellm`, in a module that is not specific to a module class.
# `nixos/modules/services/misc/litellm.nix` uses it, and
# `passthru.commandModules.litellm` of `pkgs.litellm` exposes it. See "Modules
# of a package" in the Nixpkgs manual for why it is in this directory.
#
# This module does not set `--config`. The consumer sets
# `portable.flags.config` to the configuration file.

{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    ;
in
{
  imports = [
    # Not `lib.genericModules`: the `lib` module argument may come from a
    # different Nixpkgs version than this file.
    (lib.modules.importApply ../../../../../../../lib/modules/generic/command-line.nix {
      prefix = [ "portable" ];
    })
  ];

  options = {
    package = mkOption {
      description = "The litellm package to use.";
      type = types.package;
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        The host address which the LiteLLM server HTTP interface listens to.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      example = 11111;
      description = ''
        Which port the LiteLLM server listens to.
      '';
    };
  };

  config = {
    portable.executable = getExe config.package;

    portable.flagFormat = flag: {
      option = "--${flag}";
      explicitBool = false;
      sep = null;
    };

    portable.flags = {
      inherit (config) host port;
    };
  };
}
