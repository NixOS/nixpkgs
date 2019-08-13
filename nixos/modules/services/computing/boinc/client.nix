{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.boinc;
  allowRemoteGuiRpcFlag = optionalString cfg.allowRemoteGuiRpc "--allow_remote_gui_rpc";

  fhsEnv = pkgs.buildFHSUserEnv {
    name = "boinc-fhs-env";
    targetPkgs = pkgs': [ cfg.package ] ++ cfg.extraEnvPackages;
    runScript = "/bin/boinc_client";
  };
  fhsEnvExecutable = "${fhsEnv}/bin/${fhsEnv.name}";

in
  {
    options.services.boinc = {
      enable = mkOption {
        type = types.bool;
        default = false;
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
        description = ''
          If set to true, any remote host can connect to and control this BOINC
          client (subject to password authentication). If instead set to false,
          only the hosts listed in <varname>dataDir</varname>/remote_hosts.cfg will be allowed to
          connect.

          See also: <link xlink:href="http://boinc.berkeley.edu/wiki/Controlling_BOINC_remotely#Remote_access"/>
        '';
      };

      extraEnvPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = "[ pkgs.virtualbox ]";
        description = ''
          Additional packages to make available in the environment in which
          BOINC will run. Common choices are:
          <variablelist>
            <varlistentry>
              <term><varname>pkgs.virtualbox</varname></term>
              <listitem><para>
                The VirtualBox virtual machine framework. Required by some BOINC
                projects, such as ATLAS@home.
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><varname>pkgs.ocl-icd</varname></term>
              <listitem><para>
                OpenCL infrastructure library. Required by BOINC projects that
                use OpenCL, in addition to a device-specific OpenCL driver.
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><varname>pkgs.linuxPackages.nvidia_x11</varname></term>
              <listitem><para>
                Provides CUDA libraries. Required by BOINC projects that use
                CUDA. Note that this requires an NVIDIA graphics device to be
                present on the system.
              </para><para>
                Also provides OpenCL drivers for NVIDIA GPUs;
                <varname>pkgs.ocl-icd</varname> is also needed in this case.
              </para></listitem>
            </varlistentry>
          </variablelist>
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

      systemd.tmpfiles.rules = [
        "d '${cfg.dataDir}' - boinc - - -"
      ];

      systemd.services.boinc = {
        description = "BOINC Client";
        after = ["network.target" "local-fs.target"];
        wantedBy = ["multi-user.target"];
        script = ''
          ${fhsEnvExecutable} --dir ${cfg.dataDir} --redirectio ${allowRemoteGuiRpcFlag}
        '';
        serviceConfig = {
          User = "boinc";
          Nice = 10;
        };
      };
    };

    meta = {
      maintainers = with lib.maintainers; [kierdavis];
    };
  }
