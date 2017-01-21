{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.boinc;
  allowRemoteGuiRpcFlag = optionalString cfg.allowRemoteGuiRpc "--allow_remote_gui_rpc";

  # A package providing the boinc_client that will actually be executed.
  execPkg = if cfg.useFHSEnv then
    pkgs.buildFHSUserEnv {
      name = "boinc_client";
      targetPkgs = p: [ cfg.package ]
                   ++ optional cfg.virtualbox.enable cfg.virtualbox.package;
      multiPkgs  = p: optional cfg.gpu.enable cfg.gpu.package
                   ++ optional cfg.gpu.nvidia.enable cfg.gpu.nvidia.package;
      runScript = "/bin/boinc";
    }
  else cfg.package;

in
  {
    options.services.boinc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to enable the BOINC distributed computing client. If this
          option is set to true, the boinc_client daemon will be run as a
          background service. The boinccmd command can be used to control the
          daemon.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.boinc;
        defaultText = "pkgs.boinc";
        description = ''
          Which BOINC package to use.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/boinc";
        description = ''
          The directory in which to store BOINC's configuration and data files.
        '';
      };

      allowRemoteGuiRpc = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          If set to true, any remote host can connect to and control this BOINC
          client (subject to password authentication). If instead set to false,
          only the hosts listed in <varname>dataDir</varname>/remote_hosts.cfg will be allowed to
          connect.

          See also: <link xlink:href="http://boinc.berkeley.edu/wiki/Controlling_BOINC_remotely#Remote_access"/>
        '';
      };

      useFHSEnv = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          If set to true, run the BOINC software inside an FHS-compatible
          environment. This allows BOINC project apps to find libraries that
          wouldn't be otherwise found, due to apps using hardcoded paths for
          these libraries.

          If BOINC tasks appear to be failing with the message "Computation
          Error", try enabling this option.
        '';
      };

      virtualbox.enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          If set to true, make Virtualbox available to BOINC project apps that
          require it, such as ATLAS@Home. This only works if useFHSEnv is
          enabled.
        '';
      };

      virtualbox.package = mkOption {
        type = types.package;
        default = pkgs.virtualbox;
        defaultText = "pkgs.virtualbox";
        description = ''
          Which Virtualbox package to use.
        '';
      };

      gpu.enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          If set to true, make OpenCL libraries available to BOINC project apps
          that can use them, such as GPUGRID and Moo! Wrapper. This only works
          if useFHSEnv.

          Note that for support for NVIDIA GPUs to work, you may also need to
          set <varname>gpu.nvidia.enable</varname> to true in order to make
          CUDA libraries available as well.
        '';
      };

      gpu.package = mkOption {
        type = types.package;
        default = pkgs.ocl-icd;
        defaultText = "pkgs.ocl-icd";
        description = ''
          Which ocl-icd package to use.
        '';
      };

      gpu.nvidia.enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          If set to true, make the NVIDIA CUDA libraries available to BOINC
          project apps that can use them, such as GPUGRID and Moo! Wrapper.
          This only works if useFHSEnv is enabled.
        '';
      };

      gpu.nvidia.package = mkOption {
        type = types.package;
        default = pkgs.linuxPackages.nvidia_x11.override { libsOnly = true; };
        defaultText = "pkgs.linuxPackages.nvidia_x11.override { libsOnly = true; }";
        description = ''
          Which nvidia_x11 package to use.
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [cfg.package];

      users.users.boinc = {
        createHome = false;
        description = "BOINC Client";
        home = cfg.dataDir;
        isSystemUser = true;
      };

      systemd.services.boinc = {
        description = "BOINC Client";
        after = ["network.target" "local-fs.target"];
        wantedBy = ["multi-user.target"];
        preStart = ''
          mkdir -p ${cfg.dataDir}
          chown boinc ${cfg.dataDir}
        '';
        script = ''
          ${execPkg}/bin/boinc_client --dir ${cfg.dataDir} --redirectio ${allowRemoteGuiRpcFlag}
        '';
        serviceConfig = {
          PermissionsStartOnly = true; # preStart must be run as root
          User = "boinc";
          Nice = 10;
        };
      };
    };

    meta = {
      maintainers = with lib.maintainers; [kierdavis];
    };
  }
