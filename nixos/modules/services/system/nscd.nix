{ config, lib, pkgs, ... }:

with lib;

let

  nssModulesPath = config.system.nssModules.path;
  cfg = config.services.nscd;

  nscd = if pkgs.stdenv.hostPlatform.libc == "glibc"
         then pkgs.stdenv.cc.libc.bin
         else pkgs.glibc.bin;

in

{

  ###### interface

  options = {

    services.nscd = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable the Name Service Cache Daemon.
          Disabling this is strongly discouraged, as this effectively disables NSS Lookups
          from all non-glibc NSS modules, including the ones provided by systemd.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = builtins.readFile ./nscd.conf;
        description = "Configuration to use for Name Service Cache Daemon.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.etc."nscd.conf".text = cfg.config;

    systemd.services.nscd =
      { description = "Name Service Cache Daemon";

        environment = { LD_LIBRARY_PATH = nssModulesPath; };

        # We need system users to be resolveable in late-boot.  nscd is the proxy between
        # nss-modules in NixOS and thus if you have nss-modules providing system users
        # (e.g. when using DynamicUser) then nscd needs to be available before late-boot is ready
        # We add a dependency of sysinit.target to nscd to ensure
        # these units are started after nscd is fully started.
        unitConfig.DefaultDependencies = false;
        wantedBy = [ "sysinit.target" ];
        before = [ "sysinit.target" "shutdown.target" ];
        conflicts = [ "shutdown.target" ];
        wants = [ "local-fs.target" ];
        after = [ "local-fs.target" ];

        restartTriggers = [
          config.environment.etc.hosts.source
          config.environment.etc."nsswitch.conf".source
          config.environment.etc."nscd.conf".source
        ];

        # We use DynamicUser because in default configurations nscd doesn't
        # create any files that need to survive restarts. However, in some
        # configurations, nscd needs to be started as root; it will drop
        # privileges after all the NSS modules have read their configuration
        # files. So prefix the ExecStart command with "!" to prevent systemd
        # from dropping privileges early. See ExecStart in systemd.service(5).
        serviceConfig = {
          ExecStart = "!@${nscd}/sbin/nscd nscd";
          Type = "forking";
          DynamicUser = true;
          RuntimeDirectory = "nscd";
          PIDFile = "/run/nscd/nscd.pid";
          Restart = "always";
          ExecReload = [
            "${nscd}/sbin/nscd --invalidate passwd"
            "${nscd}/sbin/nscd --invalidate group"
            "${nscd}/sbin/nscd --invalidate hosts"
          ];
        };
      };
  };
}
