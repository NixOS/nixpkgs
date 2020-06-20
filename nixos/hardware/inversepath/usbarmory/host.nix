{ dev ? "armory0" }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTRS{idVendor}=="0525", ATTRS{idProduct}=="a4a2", NAME="${staticDevName}"
  '';

  networking = {
    interfaces."${staticDevName}".ip4 = [{
      address = "10.0.0.2";
      prefixLength = 24;
    }];
    nat = {
      enable = true;
      internalInterfaces = [ dev ];
    };
    extraHosts = "10.0.0.1 armory";
  };
}
