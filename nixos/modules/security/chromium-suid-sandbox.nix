{ config, lib, pkgs, ... }:

with lib;

let
  cfg     = config.security.chromiumSuidSandbox;
  sandbox = pkgs.chromium.sandbox;
in
{
  options.security.chromiumSuidSandbox.enable = mkEnableOption ''
    Whether to install the Chromium SUID sandbox which is an executable that
    Chromium may use in order to achieve sandboxing.

    If you get the error "The SUID sandbox helper binary was found, but is not
    configured correctly.", turning this on might help.

    Also, if the URL chrome://sandbox tells you that "You are not adequately
    sandboxed!", turning this on might resolve the issue.

    Finally, if you have <option>security.grsecurity</option> enabled and you
    use Chromium, you probably need this.
  '';

  config = mkIf cfg.enable {
    environment.systemPackages = [ sandbox ];
    security.setuidPrograms    = [ sandbox.passthru.sandboxExecutableName ];
  };
}
