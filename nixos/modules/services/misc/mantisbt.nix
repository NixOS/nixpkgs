{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.mantisbt;

  freshInstall = cfg.extraConfig == "";

  # combined code+config directory
  mantisbt = let
    config_inc = pkgs.writeText "config_inc.php" ("<?php\n" + cfg.extraConfig);
    src = pkgs.fetchurl {
      url = "mirror://sourceforge/mantisbt/${name}.tar.gz";
      sha256 = "1pl6xn793p3mxc6ibpr2bhg85vkdlcf57yk7pfc399g47l8x4508";
    };
    name = "mantisbt-1.2.19";
    in
      # We have to copy every time; otherwise config won't be found.
      pkgs.runCommand name
        { preferLocalBuild = true; allowSubstitutes = false; }
        (''
          mkdir -p "$out"
          cd "$out"
          tar -xf '${src}' --strip-components=1
          ln -s '${config_inc}' config_inc.php
        ''
        + lib.optionalString (!freshInstall) "rm -r admin/"
        );
in
{
  options.services.mantisbt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the mantisbt web service.
        This switches on httpd with PHP and database.
      '';
    };
    urlPrefix = mkOption {
      type = types.string;
      default = "/mantisbt";
      description = "The URL prefix under which the mantisbt service appears.";
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        The contents of config_inc.php, without leading &lt;?php.
        If left empty, the admin directory will be accessible.
      '';
    };
  };


  config = mkIf cfg.enable {
    services.mysql.enable = true;
    services.httpd.enable = true;
    services.httpd.enablePHP = true;
    # The httpd sub-service showing mantisbt.
    services.httpd.extraSubservices = [ { function = { ... }: {
      extraConfig =
        ''
          Alias ${cfg.urlPrefix} "${mantisbt}"
        '';
    };}];
  };
}
