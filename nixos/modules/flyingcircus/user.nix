{ config, lib, pkgs, ... }:

{
  security.pam.services.sshd.showMotd = true;
  users = {
    motd = "Welcome to the Flying Circus";
  };
}
