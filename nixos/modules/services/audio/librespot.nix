{ config, pkgs, lib, ... }:

with builtins;
with lib;
with types;

let
  cfg = config.services.librespot;
in
{
  options = {
    services.librespot = {
      enable = mkEnableOption "librespot: Open Source Spotify client library";

      cache = mkOption {
        type = nullOr str;
        default = null;
        description = "Path to a directory where files will be cached.";
      };

      enableAudioCache = mkOption {
        type = bool;
        default = true;
        description = "Enable caching of the audio data.";
      };

      name = mkOption {
        type = str;
        description = "Device name";
      };

      deviceType = mkOption {
        type = enum [ "unknown" "computer" "tablet" "smarthphone" "speaker" "tv" "avr" "stb" "audiodongle" ];
        default = "speaker";
        description = "The displayed device type in Spotify clients. Can be unknown, computer, tablet, smartphone, speaker, tv, avr (Audio/Video Receiver), stb (Set-Top Box), and audiodongle. Defaults to speaker";
      };

      bitrate = mkOption {
        type = nullOr int;
        default = null;
        description = "Bitrate (96, 160 or 320). Defaults to 160";
      };

      onevent = mkOption {
        type = nullOr path;
        default = null;
        description = "The path to a script that gets run when one of librespot's events is triggered.";
      };

      verbose = mkOption {
        type = bool;
        default = false;
        description = "Enable verbose output";
      };

      username = mkOption {
        type = nullOr str;
        default = null;
        description = "Username to sign in with";
      };

      passwordFile = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/spotify-password";
        description = ''
          A file containing the password corresponding to
          <option>username</option>. Quote if you do not want to add the file to your nix store.
        '';
      };

      enableDiscovery = mkOption {
        type = bool;
        default = true;
        description = "Enable discovery mode";
      };

      device = mkOption {
        type = nullOr str;
        default = null;
        description = "Audio device to use. (Only with the rodio/portaudio/alsa backends)";
      };

      mixer = mkOption {
        type = nullOr str;
        default = null;
        description = "Mixer to use (softvol/alsa)";
      };

      mixerName = mkOption {
        type = nullOr str;
        default = null;
        description = "alsa mixer name e.g PCM or Master. Defaults to PCM";
      };

      mixerCard = mkOption {
        type = nullOr str;
        default = null;
        description = "alsa mixer card, e.g hw:0 or similar from aplay -l. Defaults to default";
      };

      mixerIndex = mkOption {
        type = nullOr int;
        default = null;
        description = "alsa mixer index, Index of the cards mixer. Defaults to 0";
      };

      initalVolume = mkOption {
        type = nullOr (ints.between 0 100);
        default = null;
        description = "Initial volume in %, once connected [0-100]";
      };

      enableVolumeNormalisation = mkOption {
        type = bool;
        default = false;
        description = "Enables volume normalisation for librespot";
      };

      normalisationPregain = mkOption {
        type = nullOr int;
        default = null;
        description = "A numeric value for pregain (dB). Only used when normalisation active.";
      };

      linearVolume = mkOption {
        type = bool;
        default = false;
        description = "Enables linear volume scaling instead of logarithmic (default) scaling";
      };

      enableGapless = mkOption {
        type = bool;
        default = true;
        description = "Enables gapless playback by forcing the sink to close b/w tracks";
      };

      zeroconfPort = mkOption {
        type = nullOr port;
        default = null;
        description = "The port that the HTTP server advertised on zeroconf will use [1-65535]. Ports <= 1024 may require root priviledges.";
      };

      proxy = mkOption {
        type = nullOr str;
        default = null;
        description = "Use a proxy for resolving the access point. Proxy should be an HTTP proxy in the form http://ip:port, and can also be passed using the all-lowercase http_proxy environment variable.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ librespot ];

    systemd.services.librespot = {
      description = "librespot";

      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = concatStringsSep " \\\n  " ([
          "${pkgs.librespot}/bin/librespot -n ${escapeShellArg cfg.name} " ]
        ++ optional (cfg.cache != null) "--cache ${escapeShellArg cfg.chache} "
        ++ optional (!cfg.enableAudioCache) "--disable-audio-cache "
        ++ optional (cfg.deviceType != "speaker") "--device-type ${escapeShellArg cfg.device-type} "
        ++ optional (cfg.bitrate != null) "-b ${toString cfg.bitrate} "
        ++ optional (cfg.onevent != null) "--onevent ${escapeShellArg cfg.onevent} "
        ++ optional (cfg.verbose) "--verbose "
        ++ optional (cfg.username != null) "--username ${escapeShellArg cfg.username} "
        ++ optional (cfg.passwordFile != null) "--password $(< ${cfg.passwordFile}) "
        ++ optional (!cfg.enableDiscovery) "--disable-discovery "
        ++ optional (cfg.device != null) "--device ${escapeShellArg cfg.device} "
        ++ optional (cfg.mixer != null) "--mixer ${escapeShellArg cfg.mixer} "
        ++ optional (cfg.mixerName != null) "--mixer-name ${escapeShellArg cfg.mixerName} "
        ++ optional (cfg.mixerCard != null) "--mixer-card ${escapeShellArg cfg.mixerCard} "
        ++ optional (cfg.mixerIndex != null) "--mixer-index ${toString cfg.mixerIndex} "
        ++ optional (cfg.initalVolume != null) "--inital-volume ${toString cfg.initalVolume} "
        ++ optional (cfg.enableVolumeNormalisation) "--enable-volume-normalisation "
        ++ optional (cfg.normalisationPregain != null) "--normalisation-pregain ${escapeShellArg cfg.normalisationPregain} "
        ++ optional (cfg.linearVolume) "--linear-volume "
        ++ optional (!cfg.enableGapless) "--disable-gapless "
        ++ optional (cfg.zeroconfPort != null) "--zeroconf-port ${toString cfg.zeroconfPort} "
        ++ optional (cfg.proxy != null) "--proxy ${escapeShellArg cfg.proxy} "
      );
      serviceConfig = {

        Type="simple";
        Restart = "always";
        RestartSec = "5s";

        DynamicUser = true;
        ProtectSystem = "strict"; # Prevent writing to most of /
        ProtectHome = true; # Prevent accessing /home and /root
        PrivateTmp = true; # Give an own directory under /tmp
        PrivateDevices = true; # Deny access to most of /dev
        ProtectKernelTunables = true; # Protect some parts of /sys
        ProtectControlGroups = true; # Remount cgroups read-only
        RestrictSUIDSGID = true; # Prevent creating SETUID/SETGID files
        PrivateMounts = true; # Give an own mount namespace

        # Capabilities
        CapabilityBoundingSet = ""; # Allow no capabilities at all
        NoNewPrivileges = true; # Disallow getting more capabilities. This is also implied by other options.

        # Kernel stuff
        ProtectKernelModules = true; # Prevent loading of kernel modules
        SystemCallArchitectures = "native"; # Usually no need to disable this
        ProtectKernelLogs = true; # Prevent access to kernel logs
        ProtectClock = true; # Prevent setting the RTC

        # Networking
        RestrictAddressFamilies = ""; # Example: "AF_UNIX AF_INET AF_INET6"
        PrivateNetwork = false;

        # Misc
        LockPersonality = true; # Prevent change of the personality
        ProtectHostname = true; # Give an own UTS namespace
        RestrictRealtime = true; # Prevent switching to RT scheduling
        MemoryDenyWriteExecute = true; # Maybe disable this for interpreters like python
        PrivateUsers = true; # If anything randomly breaks, it's mostly because of this
      };
    };
  };
}
