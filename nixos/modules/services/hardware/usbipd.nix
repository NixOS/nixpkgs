{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.usbipd;
  device = types.submodule {
    options = {
      productid = mkOption {
        type = types.str;
      };
      vendorid = mkOption {
        type = types.str;
      };
    };
  };
in
{
  options.services.usbipd = {
    enable = mkEnableOption "usbip server";
    kernelPackage = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.usbip;
      description = "The kernel module package to install.";
    };
    devices = mkOption {
      type = types.listOf device;
      default = [ ];
      description = "List of USB devices to watch and automatically export.";
      example = {
        productid = "xxxx";
        vendorid = "xxxx";
      };
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open port 3240 for usbipd";
      example = false;
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.kernelPackage ];
    boot.kernelModules = [
      "usbip-core"
      "usbip-host"
    ];
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 3240 ];
    services.udev.extraRules = strings.concatLines (
      (map (
        dev:
        "ACTION==\"add\", SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"${dev.productid}\", ATTRS{idVendor}==\"${dev.vendorid}\", RUN+=\"${pkgs.systemd}/bin/systemctl restart usbip-${dev.vendorid}:${dev.productid}.service\""
      ) cfg.devices)
    );

    systemd.services =
      (builtins.listToAttrs (
        map (dev: {
          name = "usbip-${dev.vendorid}:${dev.productid}";
          value = {
            after = [ "usbipd.service" ];
            script = ''
              set +e
              devices=$(${cfg.kernelPackage}/bin/usbip list -l | grep -E "^.*- busid.*(${dev.vendorid}:${dev.productid})" )
              echo $devices | while read device; do
                output=$(${cfg.kernelPackage}/bin/usbip -d bind -b $(echo $device | ${pkgs.gawk}/bin/awk '{ print $3 }') 2>&1)
                code=$?

                echo $output
                if [[ $output =~ "already bound" ]] || [ $code -eq 0 ]; then
                  continue
                else
                  exit $code
                fi
              done
            '';
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            restartTriggers = [ "usbipd.service" ];
          };
        }) cfg.devices
      ))
      // {
        usbipd = {
          wantedBy = [ "multi-user.target" ];
          script = ''
            ${pkgs.kmod}/bin/modprobe usbip-host usbip-core
            exec ${cfg.kernelPackage}/bin/usbipd -D
          '';
          serviceConfig.Type = "forking";
        };
      };
  };
  meta.maintainers = with maintainers; [ cbingman ];
  meta.buildDocsInSandbox = false
}
