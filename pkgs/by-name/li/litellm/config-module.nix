# Configuration of LiteLLM, as a module that maps the options to the file that
# LiteLLM reads. `pkgs.litellm.configFiles` exposes it, so that a system that
# does not use NixOS can also evaluate it.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  format = pkgs.formats.yaml { };
in
{
  options.settings = lib.mkOption {
    type = lib.types.submodule {
      freeformType = format.type;
      options = {
        model_list = lib.mkOption {
          type = format.type;
          description = ''
            List of supported models on the server, with model-specific configs.
          '';
          default = [ ];
        };
        router_settings = lib.mkOption {
          type = format.type;
          description = ''
            LiteLLM Router settings
          '';
          default = { };
        };

        litellm_settings = lib.mkOption {
          type = format.type;
          description = ''
            LiteLLM Module settings
          '';
          default = { };
        };

        general_settings = lib.mkOption {
          type = format.type;
          description = ''
            LiteLLM Server settings
          '';
          default = { };
        };

        environment_variables = lib.mkOption {
          type = format.type;
          description = ''
            Environment variables to pass to the Lite
          '';
          default = { };
        };
      };
    };
    default = { };
    description = ''
      Configuration for LiteLLM.
      See <https://docs.litellm.ai/docs/proxy/configs> for more.
    '';
  };

  config.portable.files."config.yaml".source = format.generate "config.yaml" config.settings;
}
