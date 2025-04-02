{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speechd;
  inherit (lib)
    getExe
    mapAttrs'
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    ;
in
{
  options.services.speechd = {
    # FIXME: figure out how to deprecate this EXTREMELY CAREFULLY
    # default guessed conservatively in ../misc/graphical-desktop.nix
    enable = mkEnableOption "speech-dispatcher speech synthesizer daemon";

    package = mkPackageOption pkgs "speechd" { };

    config = mkOption {
      type = with lib.types; nullOr lines;
      default = null;
      description = ''
        System wide configuration file for Speech Dispatcher. This will be used if user configuration file is not found.
      '';
      example = ''
        AddModule "module_name" "module_binary" "module_config"
      '';
    };

    modules = mkOption {
      type = with lib.types; attrsOf lines;
      default = { };
      description = ''
        Configuration files of output modules.
      '';
      example = {
        generic-epos = ''
          AddVoice        "cs"  "male1"   "kadlec"
          AddVoice        "sk"  "male1"   "bob"
        '';
      };
    };

    clients = mkOption {
      type = with lib.types; attrsOf lines;
      default = { };
      description = ''
        Client specific configuration.
      '';
      example = {
        emacs = ''
          BeginClient "emacs:*"
          # Example:
          #   DefaultPunctuationMode "some"
          EndClient
        '';
      };
    };
  };

  # FIXME: speechd 0.12 (or whatever the next version is)
  # will support socket activation, so switch to that once it's out.
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      sessionVariables.SPEECHD_CMD = getExe cfg.package;

      etc =
        if cfg.config == null then
          { speech-dispatcher.source = "${cfg.package}/etc/speech-dispatcher"; }
        else
          {
            "speech-dispatcher/speechd.conf".text = cfg.config;
          }
          // (mapAttrs' (name: value: {
            name = "speech-dispatcher/modules/${name}.conf";
            value.text = value;
          }) cfg.modules)
          // (mapAttrs' (name: value: {
            name = "speech-dispatcher/clients/${name}.conf";
            value.text = value;
          }) cfg.clients);
    };
  };
}
