{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.mycroft;

  format = pkgs.formats.json {};
  configFile = format.generate "mycroft.conf" cfg.settings;
in
{
  meta = {
    buildDocsInSandbox = false;
    maintainers = teams.mycroft.members;
  };

  options.services.mycroft = {
    enable = mkEnableOption "Mycroft, the private and open voice assistant";

    settings = mkOption {
      default = {};
      description = ''
      Configuration options for the <literal>mycroft.conf</literal>.

      Check the <link xlink:href="https://github.com/MycroftAI/mycroft-core/blob/release/${pkgs.mycroft.core.version}/mycroft/configuration/mycroft.conf">example configuration</link> for both possible and default values.
      '';
      type = types.submodule {
        freeformType = format.type;
        options = {
          data_dir = mkOption {
            type = types.str;
            default = "/var/lib/mycroft";
            description = ''
              Path to Mycroft's state directory.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.mycroft = {
      group = "mycroft";
      home = cfg.settings.data_dir;
      createHome = true;
      isSystemUser = true;
    };

    users.groups.mycroft = {
    };

    environment.etc."mycroft/mycroft.conf".source = configFile;

    systemd.targets.mycroft = {
      description = "Mycroft Voice Assistant";
      after = [
        "network-online.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
    };

    systemd.services = let
      commonUnitConfig = name: {
        description = "Mycroft ${name}";
        partOf = [
          "mycroft.target"
        ];
        wantedBy = [
          "mycroft.target"
        ];
        restartTriggers = [
          configFile
        ];
      };

      commonServiceConfig = {
        User = "mycroft";
        Group = "mycroft";
        WorkingDirectory = "/var/lib/mycroft";
      };
    in
    {
      mycroft-messagebus = {
        serviceConfig = {
          ExecStart = "${pkgs.mycroft.core}/bin/mycroft-messagebus";
        } // commonServiceConfig;
      } // commonUnitConfig "Message Bus";

      mycroft-skills = {
        requires = [
          "mycroft-messagebus.service"
        ];
        serviceConfig = {
          ExecStart = "${pkgs.mycroft.core}/bin/mycroft-skills";
        } // commonServiceConfig;
      } // commonUnitConfig "Skills";

      mycroft-audio = {
        requires = [
          "mycroft-messagebus.service"
        ];
        path = with pkgs; [
          mpg123
          pulseaudio
          vorbis-tools
        ];
        serviceConfig = {
          ExecStart = "${pkgs.mycroft.core}/bin/mycroft-audio";
          SupplementaryGroups = [
            "audio"
            "pipewire"
          ];
        } // commonServiceConfig;
      } // commonUnitConfig "Audio Playback";

      mycroft-speech-client = {
        requires = [
          "mycroft-messagebus.service"
        ];
        serviceConfig = {
          ExecStart = "${pkgs.mycroft.core}/bin/mycroft-speech-client";
          SupplementaryGroups = [
            "audio"
            "pipewire"
          ];
        } // commonServiceConfig;
      } // commonUnitConfig "Voice capture";
    };
  };
}
