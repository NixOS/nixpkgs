{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.jibri;

  format = pkgs.formats.hocon { };

  # We're passing passwords in environment variables that have names generated
  # from an attribute name, which may not be a valid bash identifier.
  toVarName =
    s:
    "XMPP_PASSWORD_" + stringAsChars (c: if builtins.match "[A-Za-z0-9]" c != null then c else "_") s;

  defaultJibriConfig = {
    id = "";
    single-use-mode = false;

    api = {
      http.external-api-port = 2222;
      http.internal-api-port = 3333;

      xmpp.environments = flip mapAttrsToList cfg.xmppEnvironments (
        name: env: {
          inherit name;

          xmpp-server-hosts = env.xmppServerHosts;
          xmpp-domain = env.xmppDomain;
          control-muc = {
            domain = env.control.muc.domain;
            room-name = env.control.muc.roomName;
            nickname = env.control.muc.nickname;
          };

          control-login = {
            domain = env.control.login.domain;
            username = env.control.login.username;
            password = format.lib.mkSubstitution (toVarName "${name}_control");
          };

          call-login = {
            domain = env.call.login.domain;
            username = env.call.login.username;
            password = format.lib.mkSubstitution (toVarName "${name}_call");
          };

          strip-from-room-domain = env.stripFromRoomDomain;
          usage-timeout = env.usageTimeout;
          trust-all-xmpp-certs = env.disableCertificateVerification;
        }
      );
    };

    recording = {
      recordings-directory = "/tmp/recordings";
      finalize-script = "${cfg.finalizeScript}";
    };

    streaming.rtmp-allow-list = [ ".*" ];

    chrome.flags = [
      "--use-fake-ui-for-media-stream"
      "--start-maximized"
      "--kiosk"
      "--enabled"
      "--disable-infobars"
      "--autoplay-policy=no-user-gesture-required"
    ]
    ++ lists.optional cfg.ignoreCert "--ignore-certificate-errors";

    stats.enable-stats-d = true;
    webhook.subscribers = [ ];

    jwt-info = { };

    call-status-checks = {
      no-media-timout = "30 seconds";
      all-muted-timeout = "10 minutes";
      default-call-empty-timout = "30 seconds";
    };
  };
  # Allow overriding leaves of the default config despite types.attrs not doing any merging.
  jibriConfig = recursiveUpdate defaultJibriConfig cfg.config;
  configFile = format.generate "jibri.conf" { jibri = jibriConfig; };
in
{
  options.services.jibri = with types; {
    enable = mkEnableOption "Jitsi BRoadcasting Infrastructure. Currently Jibri must be run on a host that is also running {option}`services.jitsi-meet.enable`, so for most use cases it will be simpler to run {option}`services.jitsi-meet.jibri.enable`";
    config = mkOption {
      type = format.type;
      default = { };
      description = ''
        Jibri configuration.
        See <https://github.com/jitsi/jibri/blob/master/src/main/resources/reference.conf>
        for default configuration with comments.
      '';
    };

    finalizeScript = mkOption {
      type = types.path;
      default = pkgs.writeScript "finalize_recording.sh" ''
        #!/bin/sh

        RECORDINGS_DIR=$1

        echo "This is a dummy finalize script" > /tmp/finalize.out
        echo "The script was invoked with recordings directory $RECORDINGS_DIR." >> /tmp/finalize.out
        echo "You should put any finalize logic (renaming, uploading to a service" >> /tmp/finalize.out
        echo "or storage provider, etc.) in this script" >> /tmp/finalize.out

        exit 0
      '';
      defaultText = literalExpression ''
        pkgs.writeScript "finalize_recording.sh" ''''''
        #!/bin/sh

        RECORDINGS_DIR=$1

        echo "This is a dummy finalize script" > /tmp/finalize.out
        echo "The script was invoked with recordings directory $RECORDINGS_DIR." >> /tmp/finalize.out
        echo "You should put any finalize logic (renaming, uploading to a service" >> /tmp/finalize.out
        echo "or storage provider, etc.) in this script" >> /tmp/finalize.out

        exit 0
        '''''';
      '';
      example = literalExpression ''
        pkgs.writeScript "finalize_recording.sh" ''''''
        #!/bin/sh
        RECORDINGS_DIR=$1
        ''${pkgs.rclone}/bin/rclone copy $RECORDINGS_DIR RCLONE_REMOTE:jibri-recordings/ -v --log-file=/var/log/jitsi/jibri/recording-upload.txt
        exit 0
        '''''';
      '';
      description = ''
        This script runs when jibri finishes recording a video of a conference.
      '';
    };

    ignoreCert = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Whether to enable the flag "--ignore-certificate-errors" for the Chromium browser opened by Jibri.
        Intended for use in automated tests or anywhere else where using a verified cert for Jitsi-Meet is not possible.
      '';
    };

    xmppEnvironments = mkOption {
      description = ''
        XMPP servers to connect to.
      '';
      example = literalExpression ''
        "jitsi-meet" = {
          xmppServerHosts = [ "localhost" ];
          xmppDomain = config.services.jitsi-meet.hostName;

          control.muc = {
            domain = "internal.''${config.services.jitsi-meet.hostName}";
            roomName = "JibriBrewery";
            nickname = "jibri";
          };

          control.login = {
            domain = "auth.''${config.services.jitsi-meet.hostName}";
            username = "jibri";
            passwordFile = "/var/lib/jitsi-meet/jibri-auth-secret";
          };

          call.login = {
            domain = "recorder.''${config.services.jitsi-meet.hostName}";
            username = "recorder";
            passwordFile = "/var/lib/jitsi-meet/jibri-recorder-secret";
          };

          usageTimeout = "0";
          disableCertificateVerification = true;
          stripFromRoomDomain = "conference.";
        };
      '';
      default = { };
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              xmppServerHosts = mkOption {
                type = listOf str;
                example = [ "xmpp.example.org" ];
                description = ''
                  Hostnames of the XMPP servers to connect to.
                '';
              };
              xmppDomain = mkOption {
                type = str;
                example = "xmpp.example.org";
                description = ''
                  The base XMPP domain.
                '';
              };
              control.muc.domain = mkOption {
                type = str;
                description = ''
                  The domain part of the MUC to connect to for control.
                '';
              };
              control.muc.roomName = mkOption {
                type = str;
                default = "JibriBrewery";
                description = ''
                  The room name of the MUC to connect to for control.
                '';
              };
              control.muc.nickname = mkOption {
                type = str;
                default = "jibri";
                description = ''
                  The nickname for this Jibri instance in the MUC.
                '';
              };
              control.login.domain = mkOption {
                type = str;
                description = ''
                  The domain part of the JID for this Jibri instance.
                '';
              };
              control.login.username = mkOption {
                type = str;
                default = "jvb";
                description = ''
                  User part of the JID.
                '';
              };
              control.login.passwordFile = mkOption {
                type = str;
                example = "/run/keys/jibri-xmpp1";
                description = ''
                  File containing the password for the user.
                '';
              };

              call.login.domain = mkOption {
                type = str;
                example = "recorder.xmpp.example.org";
                description = ''
                  The domain part of the JID for the recorder.
                '';
              };
              call.login.username = mkOption {
                type = str;
                default = "recorder";
                description = ''
                  User part of the JID for the recorder.
                '';
              };
              call.login.passwordFile = mkOption {
                type = str;
                example = "/run/keys/jibri-recorder-xmpp1";
                description = ''
                  File containing the password for the user.
                '';
              };
              disableCertificateVerification = mkOption {
                type = bool;
                default = false;
                description = ''
                  Whether to skip validation of the server's certificate.
                '';
              };

              stripFromRoomDomain = mkOption {
                type = str;
                default = "0";
                example = "conference.";
                description = ''
                  The prefix to strip from the room's JID domain to derive the call URL.
                '';
              };
              usageTimeout = mkOption {
                type = str;
                default = "0";
                example = "1 hour";
                description = ''
                  The duration that the Jibri session can be.
                  A value of zero means indefinitely.
                '';
              };
            };

            config =
              let
                nick = mkDefault (
                  builtins.replaceStrings [ "." ] [ "-" ] (
                    config.networking.hostName
                    + optionalString (config.networking.domain != null) ".${config.networking.domain}"
                  )
                );
              in
              {
                call.login.username = nick;
                control.muc.nickname = nick;
              };
          }
        )
      );
    };
  };

  config = mkIf cfg.enable {
    users.groups.jibri = { };
    users.groups.plugdev = { };
    users.users.jibri = {
      isSystemUser = true;
      group = "jibri";
      home = "/var/lib/jibri";
      extraGroups = [
        "jitsi-meet"
        "adm"
        "audio"
        "video"
        "plugdev"
      ];
    };

    systemd.services.jibri-xorg = {
      description = "Jitsi Xorg Process";

      after = [ "network.target" ];
      wantedBy = [
        "jibri.service"
        "jibri-icewm.service"
      ];

      preStart = ''
        cp --no-preserve=mode,ownership ${pkgs.jibri}/etc/jitsi/jibri/* /var/lib/jibri
        mv /var/lib/jibri/{,.}asoundrc
      '';

      environment.DISPLAY = ":0";
      serviceConfig = {
        Type = "simple";

        User = "jibri";
        Group = "jibri";
        KillMode = "process";
        Restart = "on-failure";
        RestartPreventExitStatus = 255;

        StateDirectory = "jibri";

        ExecStart = "${pkgs.xorg.xorgserver}/bin/Xorg -nocursor -noreset +extension RANDR +extension RENDER -config ${pkgs.jibri}/etc/jitsi/jibri/xorg-video-dummy.conf -logfile /dev/null :0";
      };
    };

    systemd.services.jibri-icewm = {
      description = "Jitsi Window Manager";

      requires = [ "jibri-xorg.service" ];
      after = [ "jibri-xorg.service" ];
      wantedBy = [ "jibri.service" ];

      environment.DISPLAY = ":0";
      serviceConfig = {
        Type = "simple";

        User = "jibri";
        Group = "jibri";
        Restart = "on-failure";
        RestartPreventExitStatus = 255;

        StateDirectory = "jibri";

        ExecStart = "${pkgs.icewm}/bin/icewm-session";
      };
    };

    systemd.services.jibri = {
      description = "Jibri Process";

      requires = [
        "jibri-icewm.service"
        "jibri-xorg.service"
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        chromedriver
        chromium
        ffmpeg-full
      ];

      script =
        (concatStrings (
          mapAttrsToList (name: env: ''
            export ${toVarName "${name}_control"}=$(cat ${env.control.login.passwordFile})
            export ${toVarName "${name}_call"}=$(cat ${env.call.login.passwordFile})
          '') cfg.xmppEnvironments
        ))
        + ''
          ${pkgs.jdk11_headless}/bin/java -Djava.util.logging.config.file=${./logging.properties-journal} -Dconfig.file=${configFile} -jar ${pkgs.jibri}/opt/jitsi/jibri/jibri.jar --config /var/lib/jibri/jibri.json
        '';

      environment.HOME = "/var/lib/jibri";

      serviceConfig = {
        Type = "simple";

        User = "jibri";
        Group = "jibri";
        Restart = "always";
        RestartPreventExitStatus = 255;

        StateDirectory = "jibri";
      };
    };

    systemd.tmpfiles.settings."10-jibri"."/var/log/jitsi/jibri".d = {
      user = "jibri";
      group = "jibri";
      mode = "755";
    };

    # Configure Chromium to not show the "Chrome is being controlled by automatic test software" message.
    environment.etc."chromium/policies/managed/managed_policies.json".text = builtins.toJSON {
      CommandLineFlagSecurityWarningsEnabled = false;
    };
    warnings = [
      "All security warnings for Chromium have been disabled. This is necessary for Jibri, but it also impacts all other uses of Chromium on this system."
    ];

    boot = {
      extraModprobeConfig = ''
        options snd-aloop enable=1,1,1,1,1,1,1,1
      '';
      kernelModules = [ "snd-aloop" ];
    };
  };

  meta.maintainers = lib.teams.jitsi.members;
}
