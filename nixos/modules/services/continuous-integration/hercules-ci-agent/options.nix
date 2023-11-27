{ config, lib, pkgs, ... }:

let
  systemConfig = config;
in
{ config, name, ... }:
let
  inherit (lib) types;
in
{
  options = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      Hercules CI Agent as a system service.

      [Hercules CI](https://hercules-ci.com) is a
      continuous integation service that is centered around Nix.

      Support is available at [help@hercules-ci.com](mailto:help@hercules-ci.com).
    '');

    package = lib.mkPackageOptionMD pkgs "hercules-ci-agent" { };

    user = lib.mkOption {
      type = types.str;
      default = "hci-${name}";
      description = lib.mdDoc "User account under which hercules-ci-agent runs.";
      internal = true;
    };

    group = lib.mkOption {
      type = types.str;
      default = "hci-${name}";
      description = lib.mdDoc "Group account under which hercules-ci-agent runs.";
      internal = true;
    };

    settings = lib.mkOption {
      type = types.submodule (import ./settings.nix { inherit systemConfig lib name pkgs; agent = config; });
      default = { };
      description = lib.mdDoc ''
        These settings are written to the `agent.toml` file.

        Not all settings are listed as options, can be set nonetheless.

        For the exhaustive list of settings, see <https://docs.hercules-ci.com/hercules-ci/reference/agent-config/>.
      '';
    };

    tomlFile = lib.mkOption {
      type = types.path;
      internal = true;
      defaultText = lib.literalMD "generated `hercules-ci-agent-${name}.toml`";
      description = lib.mdDoc ''
        The fully assembled config file.
      '';
    };
  };

  config = {
    tomlFile = (pkgs.formats.toml { }).generate "hercules-ci-agent-${name}.toml" config.settings;
  };
}
