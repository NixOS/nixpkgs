#
# Module for hosting the USB Armory
#

{ ... }:

let
  staticDevName = "armory0";
in

{
  imports = [ ../../lib/hardware-notes.nix ];

  hardwareNotes =
    [ { title = "USB Armory network interface support";
        text =
          '' - rename the Armory USB network interface
             - set Armory inteface ip to 10.0.0.2/24
             - enable NAT and forward Armory interface
             - add the name 'armory' to /etc/hosts
          '';
      }
    ];

  services.udev.extraRules =
    ''SUBSYSTEM=="net", ACTION=="add", ATTRS{idVendor}=="0525", ATTRS{idProduct}=="a4a2", NAME="${staticDevName}"'';

  networking =
    { interfaces."${staticDevName}".ip4 = [{ address = "10.0.0.2"; prefixLength = 24; }];
      nat = { enable = true; internalInterfaces = [ staticDevName ]; };
      extraHosts = "10.0.0.1 armory";
    };

}
