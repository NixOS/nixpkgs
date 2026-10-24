{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.usbipd;
  device = lib.types.submodule {
    options = {
      productid = lib.mkOption {
        type = lib.types.str;
        description = "The product id of the device";
      };
      vendorid = lib.mkOption {
        type = lib.types.str;
        description = "The vendor id of the device";
      };
    };
  };
in
{
  options.services.usbipd = {
    enable = lib.mkEnableOption "usbip server";
    kernelPackage = lib.mkPackageOption pkgs.linuxPackages_latest "usbip" { };
    devices = lib.mkOption {
      type = lib.types.listOf device;
      default = [ ];
      description = "List of USB devices to watch and automatically export.";
      example = [
        {
          productid = "xxxx";
          vendorid = "xxxx";
        }
      ];
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open port 3240 for usbipd";
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.kernelPackage ];
    boot.kernelModules = [
      "usbip-core"
      "usbip-host"
    ];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 3240 ];
    services.udev.extraRules = lib.strings.concatLines (
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
            ${lib.getExe' pkgs.kmod "modprobe"} usbip-host usbip-core
            exec ${lib.getExe' cfg.kernelPackage "usbipd"} -D
          '';
          serviceConfig.Type = "forking";
        };
      };
  };
  meta.maintainers = with lib.maintainers; [ cbingman ];
  meta.buildDocsInSandbox = false;
}
