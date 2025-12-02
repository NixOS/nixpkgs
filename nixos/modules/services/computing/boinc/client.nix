{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.boinc;
  allowRemoteGuiRpcFlag = lib.optionalString cfg.allowRemoteGuiRpc "--allow_remote_gui_rpc";

  fhsEnv = pkgs.buildFHSEnv {
    name = "boinc-fhs-env";
    targetPkgs = pkgs': [ cfg.package ] ++ cfg.extraEnvPackages;
    runScript = "/bin/boinc_client";
  };
  fhsEnvExecutable = "${fhsEnv}/bin/${fhsEnv.name}";

in
{
  options.services.boinc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable the BOINC distributed computing client. If this
        option is set to true, the boinc_client daemon will be run as a
        background service. The boinccmd command can be used to control the
        daemon.
      '';
    };

    package = lib.mkPackageOption pkgs "boinc" {
      example = "boinc-headless";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/boinc";
      description = ''
        The directory in which to store BOINC's configuration and data files.
      '';
    };

    allowRemoteGuiRpc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If set to true, any remote host can connect to and control this BOINC
        client (subject to password authentication). If instead set to false,
        only the hosts listed in {var}`dataDir`/remote_hosts.cfg will be allowed to
        connect.

        See also: <https://boinc.berkeley.edu/wiki/Controlling_BOINC_remotely#Remote_access>
      '';
    };

    extraEnvPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.virtualbox ]";
      description = ''
        Additional packages to make available in the environment in which
        BOINC will run. Common choices are:

        - {var}`pkgs.virtualbox`:
          The VirtualBox virtual machine framework. Required by some BOINC
          projects, such as ATLAS@home.
        - {var}`pkgs.ocl-icd`:
          OpenCL infrastructure library. Required by BOINC projects that
          use OpenCL, in addition to a device-specific OpenCL driver.
        - {var}`pkgs.linuxPackages.nvidia_x11`:
          Provides CUDA libraries. Required by BOINC projects that use
          CUDA. Note that this requires an NVIDIA graphics device to be
          present on the system.

          Also provides OpenCL drivers for NVIDIA GPUs;
          {var}`pkgs.ocl-icd` is also needed in this case.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.boinc = {
      group = "boinc";
      createHome = false;
      description = "BOINC Client";
      home = cfg.dataDir;
      isSystemUser = true;
    };
    users.groups.boinc = { };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - boinc boinc - -"
    ];

    systemd.services.boinc = {
      description = "BOINC Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        exec ${fhsEnvExecutable} --dir ${cfg.dataDir} ${allowRemoteGuiRpcFlag}
      '';
      serviceConfig = {
        User = "boinc";
        Nice = 10;
      };
    };
  };

  meta = {
    maintainers = [ ];
  };
}
