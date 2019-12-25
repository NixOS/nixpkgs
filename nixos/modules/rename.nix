{ lib, pkgs, ... }:

with lib;

{
  imports = [
    /*
    This file defines some renaming/removing options for backwards compatibility

    It should ONLY be used when the relevant module can't define these imports
    itself, such as when the module was removed completely.
    See https://github.com/NixOS/nixpkgs/pull/61570 for explanation
    */

    # This alias module can't be where _module.check is defined because it would
    # be added to submodules as well there
    (mkAliasOptionModule [ "environment" "checkConfigurationOptions" ] [ "_module" "check" ])

    # Completely removed modules
    (mkRemovedOptionModule [ "services" "firefox" "syncserver" "user" ] "")
    (mkRemovedOptionModule [ "services" "firefox" "syncserver" "group" ] "")
    (mkRemovedOptionModule [ "services" "winstone" ] "The corresponding package was removed from nixpkgs.")
    (mkRemovedOptionModule [ "networking" "vpnc" ] "Use environment.etc.\"vpnc/service.conf\" instead.")
    (mkRemovedOptionModule [ "environment.blcr.enable" ] "The BLCR module has been removed")
    (mkRemovedOptionModule [ "services.beegfsEnable" ] "The BeeGFS module has been removed")
    (mkRemovedOptionModule [ "services.beegfs" ] "The BeeGFS module has been removed")
    (mkRemovedOptionModule [ "services.osquery" ] "The osquery module has been removed")
    (mkRemovedOptionModule [ "services.fourStore" ] "The fourStore module has been removed")
    (mkRemovedOptionModule [ "services.fourStoreEndpoint" ] "The fourStoreEndpoint module has been removed")

    # Do NOT add any option renames here, see top of the file
  ];
}
