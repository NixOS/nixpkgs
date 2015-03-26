# This module gets rid of all dependencies on X11 client libraries
# (including fontconfig).

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.environment.xlibs;
in

{
  options = {
    environment.xlibs = mkOption {
      type = types.enum ["yes" "no-nixos" "no"];
      default = "yes";
      description = ''
        Whenever X11-related libraries are allowed in the system.

        <literal>yes</literal> allows unrestricted usage (the default).

        <literal>no-nixos</literal> switches off the options in the
        default configuration that require X11 libraries. This
        includes client-side font configuration and SSH forwarding of
        X11 authentication in. Thus, you probably do not want this if
        you want to run X11 programs on this machine via SSH.

        <literal>no</literal> does the same stuff as
        <literal>no-nixos</literal> but also completely disallows any
        X11-related libraries in nixpkgs. Thus, you probably do not
        want this if you want to have anything X11-capable in
        <option>environment.systemPackages</option> or NixOS services.
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg != "yes") {
      programs.ssh.setXAuthLocation = false;
      security.pam.services.su.forwardXAuth = lib.mkForce false;

      fonts.fontconfig.enable = false;

      nixpkgs.config = {
        dbus.x11Support = false;
        python27.x11Support = false;
      };
    })
    (mkIf (cfg == "no") {
      nixpkgs.config.packageOverrides = pkgs: {
        xorg = {};
        xlibsWrapper = {};
      };
    })
  ];
}
