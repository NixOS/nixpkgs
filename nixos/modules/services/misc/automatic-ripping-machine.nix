{ lib, config, pkgs, ... }:


let 
  cfg = config.services.arm;
  # Python interpreter with all required Python packages for ARM
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pyyaml
    netifaces
    bcrypt
    flask
    flask_migrate
    flask_cors
    flask_sqlalchemy
    sqlalchemy
    flask_wtf
    flask_login
    pyudev
    prettytable
    musicbrainzngs
    discid    # MusicBrainz disc ID bindings
    xmltodict
    waitress
    apprise
    # (pydvdid is not packaged in nixpkgs at the moment; omitted)
  ] ++ cfg.extraPythonPackages);
in {

  #### Module Options ####
  options.services.arm = {
    enable = mkEnableOption ''
        the Automatic Ripping Machine (ARM) service.
        When enabled, a service will run to monitor optical drives and a web UI 
        will be available for interaction
      '';

    package = mkPackageOption pkgs "automatic-ripping-machine" { };

    extraPythonPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional Python packages to include in ARM's Python environment (for extending functionality or custom versions).";
    };
  };

  #### Module Implementation ####
  config = mkIf cfg.enable {
    # Create 'arm' system user and group
    users.groups.arm = { };
    users.users.arm = {
      description  = "Automatic Ripping Machine daemon";
      isSystemUser = true;
      group        = "arm";
      home         = "/home/arm";
      createHome   = true;
      shell        = pkgs.shells.nologin;  # disable interactive login
    };

    # Create necessary directories under /home/arm with proper ownership:contentReference[oaicite:11]{index=11}
    systemd.tmpfiles.rules = [
      "d /home/arm 0755 arm arm"
      "d /home/arm/logs 0755 arm arm"
      "d /home/arm/logs/progress 0755 arm arm"
      "d /home/arm/media 0755 arm arm"
      "d /home/arm/media/transcode 0755 arm arm"
      "d /home/arm/media/completed 0755 arm arm"
      "d /home/arm/media/raw 0755 arm arm"
      "d /home/arm/music 0755 arm arm"
      # Ensure config dir exists and is owned by arm
      "d /etc/arm 0775 arm arm"
      "d /etc/arm/config 0775 arm arm"
    ];

    # Deploy default configuration files (if not overridden by user)
    environment.etc."arm/config/arm.yaml".source      = "${cfg.package}/setup/arm.yaml";
    environment.etc."arm/config/apprise.yaml".source  = "${cfg.package}/setup/apprise.yaml";
    environment.etc.".abcde.conf".source              = "${cfg.package}/setup/.abcde.conf";
    environment.etc."arm/config/abcde.conf".source    = "${cfg.package}/setup/.abcde.conf";
    # (These files will be owned by root by default; the tmpfiles rule above makes /etc/arm owned by arm:arm.
    # Alternatively, you could set owner here if needed:
    # environment.etc."arm/config/arm.yaml".owner = "arm"; etc.)

    # Include udev rules for optical drive auto-detection:contentReference[oaicite:12]{index=12}
    services.udev.packages = [ cfg.package ];

    # Ensure required external programs are installed in PATH
    environment.systemPackages = with pkgs; [
      handbrake   # HandBrake CLI (for video transcoding)
      ffmpeg      # FFmpeg (for video preview/thumbnails, etc.)
      abcde       # ABCDE (for audio CD ripping)
      glyr        # Glyr (for fetching album art in ABCDE)
      flac        # FLAC encoder (used by ABCDE for lossless audio)
      cdparanoia  # CD audio ripping library (used by ABCDE)
      lsdvd       # DVD content lister (used to identify DVD tracks)
      at          # 'at' job scheduler (used to schedule transcoding tasks)
    ] ++ optional (pkgs? makemkv && pkgs.makemkv != null) pkgs.makemkv;
    # (Note: MakeMKV is unfree; enable nixpkgs.config.allowUnfree to include it for Blu-ray decryption)

    # Define the ARM UI service (web UI and disc monitor)
    systemd.services.armui = {
      description = "Automatic Ripping Machine Web UI";
      wants       = [ "network-online.target" ];
      after       = [ "network-online.target" ];
      user        = "arm";
      group       = "arm";
      # It may be useful to set a working directory, e.g. /home/arm, for writing logs or temp files
      WorkingDirectory = "/home/arm";
      # Use the Python environment with all dependencies, and run the ARM UI script
      serviceConfig = {
        ExecStart = "${pythonEnv}/bin/python3 ${cfg.package}/opt/arm/arm/runui.py";
        Restart   = "always";
        RestartSec = 5;
        # Route output to syslog (optional: ARM's rsyslog rule can direct this to /var/log/arm.log)
        StandardOutput = "syslog";
        StandardError  = "syslog";
      };
      WantedBy = [ "multi-user.target" ];
    };

    # (Optional) Add an rsyslog rule to isolate ARM logs (if rsyslog is used)
    # This would direct ARM's logs to /var/log/arm.log, similar to the upstream installer:contentReference[oaicite:13]{index=13}:
    # services.rsyslog.extraConfig = ''
    #   if $programname == "ARM" then /var/log/arm.log
    # '';
  };
}
