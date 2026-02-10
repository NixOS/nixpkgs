{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.chromiumSuidSandbox;
  sandbox = pkgs.chromium.sandbox;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "unity3d" "enable" ]
      [ "security" "chromiumSuidSandbox" "enable" ]
    )
  ];

  options.security.chromiumSuidSandbox.enable = lib.mkOption {
    type = lib.types.bool;
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

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ sandbox ];
    security.wrappers.${sandbox.passthru.sandboxExecutableName} = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${sandbox}/bin/${sandbox.passthru.sandboxExecutableName}";
    };
  };
}
