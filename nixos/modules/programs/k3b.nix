{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [
      "programs"
      "k3b"
      "enable"
    ] "Please add kdePackages.k3b to environment.systemPackages instead")
  ];
}
