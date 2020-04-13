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
    (mkRemovedOptionModule [ "environment" "blcr" "enable" ] "The BLCR module has been removed")
    (mkRemovedOptionModule [ "services" "beegfsEnable" ] "The BeeGFS module has been removed")
    (mkRemovedOptionModule [ "services" "beegfs" ] "The BeeGFS module has been removed")
    (mkRemovedOptionModule [ "services" "osquery" ] "The osquery module has been removed")
    (mkRemovedOptionModule [ "services" "fourStore" ] "The fourStore module has been removed")
    (mkRemovedOptionModule [ "services" "fourStoreEndpoint" ] "The fourStoreEndpoint module has been removed")
    (mkRemovedOptionModule [ "programs" "way-cooler" ] ("way-cooler is abandoned by its author: " +
      "https://way-cooler.org/blog/2020/01/09/way-cooler-post-mortem.html"))
    (mkRemovedOptionModule [ "services" "xserver" "multitouch" ] ''
      services.xserver.multitouch (which uses xf86_input_mtrack) has been removed
      as the underlying package isn't being maintained. Working alternatives are
      libinput and synaptics.
    '')
    (mkRemovedOptionModule [ "services" "xserver" "displayManager" "auto" ] ''
      The services.xserver.displayManager.auto module has been removed
      because it was only intended for use in internal NixOS tests, and gave the
      false impression of it being a special display manager when it's actually
      LightDM. Please use the services.xserver.displayManager.lightdm.autoLogin options
      instead, or any other display manager in NixOS as they all support auto-login.
    '')
    (mkRemovedOptionModule [ "services" "dnscrypt-proxy" ] "Use services.dnscrypt-proxy2 instead")
    (mkRemovedOptionModule ["hardware" "brightnessctl" ] ''
      The brightnessctl module was removed because newer versions of
      brightnessctl don't require the udev rules anymore (they can use the
      systemd-logind API). Instead of using the module you can now
      simply add the brightnessctl package to environment.systemPackages.
    '')

    # Do NOT add any option renames here, see top of the file
  ];
}
