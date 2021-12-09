{ config, lib, utils, pkgs, ... }:

with lib;

let

  cfg = config.environment;
in
{
  options = {
    environment.binsh = mkOption {
      default = "${config.system.build.binsh}/bin/sh";
      defaultText = literalExpression ''"''${config.system.build.binsh}/bin/sh"'';
      example = literalExpression ''"''${pkgs.dash}/bin/dash"'';
      type = types.path;
      visible = false;
      description = ''
        The shell executable that is linked system-wide to
        <literal>/bin/sh</literal>. Please note that NixOS assumes all
        over the place that shell to be Bash, so override the default
        setting only if you know exactly what you're doing.
      '';
    };
  };


  config = {
    system.build.binsh = pkgs.bashInteractive;

    system.activationScripts.binsh = stringAfter [ "stdio" ]
      ''
        # Create the required /bin/sh symlink; otherwise lots of things
        # (notably the system() function) won't work.
        mkdir -m 0755 -p /bin
        ln -sfn "${cfg.binsh}" /bin/.sh.tmp
        mv /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
      '';

  };
}
