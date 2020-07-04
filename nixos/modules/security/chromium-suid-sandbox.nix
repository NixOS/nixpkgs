{ config, lib, pkgs, ... }:

with lib;

let
  cfg     = config.security.chromiumSuidSandbox;
  sandbox = pkgs.chromium.sandbox;
in
{
  imports = [
    (mkRenamedOptionModule [ "programs" "unity3d" "enable" ] [ "security" "chromiumSuidSandbox" "enable" ])
  ];

  options.security.chromiumSuidSandbox.enable = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether to install the Chromium SUID sandbox which is an executable that
      Chromium may use in order to achieve sandboxing.

      If you get the error "The SUID sandbox helper binary was found, but is not
      configured correctly.", turning this on might help.

      Also, if the URL chrome://sandbox tells you that "You are not adequately
      sandboxed!", turning this on might resolve the issue.
    '';
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ sandbox ];
    security.wrappers.${sandbox.passthru.sandboxExecutableName}.source = "${sandbox}/bin/${sandbox.passthru.sandboxExecutableName}";
  };
}
