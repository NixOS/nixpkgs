{ lib, ... }:
with lib;
{
  imports = singleton ../lib/kernerl-version.nix;

  kernelAtleast = singleton
    { version = "3.18";
      msg = "Cypress APA touchpad supported added in Linux-3.17-rc1";
    };
}
