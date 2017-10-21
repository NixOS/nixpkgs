{ config, pkgs, ... }:

{

  environment.systemPackages = [ pkgs.mdadm ];

  services.udev.packages = [ pkgs.mdadm ];

  boot.initrd.availableKernelModules = [ "md_mod" "raid0" "raid1" "raid456" ];

  boot.initrd.extraUdevRulesCommands = ''
    cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/
  '';

  systemd.services.mdadm-shutdown = {
    wantedBy = [ "final.target"];
    after = [ "umount.target" ];

    unitConfig = {
      DefaultDependencies = false;
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''${pkgs.mdadm}/bin/mdadm --wait-clean --scan'';
    };
  };

  systemd.services."mdmon@" = {
    description = "MD Metadata Monitor on /dev/%I";

    unitConfig.DefaultDependencies = false;

    serviceConfig = {
      Type = "forking";
      Environment = "IMSM_NO_PLATFORM=1";
      ExecStart = ''${pkgs.mdadm}/bin/mdmon --offroot --takeover %I'';
      KillMode = "none";
    };
  };

  systemd.services."mdadm-grow-continue@" = {
    description = "Manage MD Reshape on /dev/%I";

    unitConfig.DefaultDependencies = false;

    serviceConfig = {
      ExecStart = ''${pkgs.mdadm}/bin/mdadm --grow --continue /dev/%I'';
      StandardInput = "null";
      StandardOutput = "null";
      StandardError = "null";
      KillMode = "none";
    };
  };
 
}
