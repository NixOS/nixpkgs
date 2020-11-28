# http://www.supermicro.com/products/motherboard/Atom/X10/A1SRi-2758F.cfm
# This board contains a TPM header, but you must supply your own module.

{ pkgs, ... }:

{
  boot.kernelModules = [ "ipmi_devintf" "ipmi_si" ];
  environment.systemPackages = [ pkgs.ipmitool ];
}
