{ config, lib, pkgs, ... }:

with lib;

let
  phabricatorRoot = pkgs.phabricator;
in {

  enablePHP = true;
  extraApacheModules = [ "mod_rewrite" ];
  DocumentRoot = "${phabricatorRoot}/phabricator/webroot";

  options = {
      git = mkOption {
          default = true;
          description = "Enable git repositories.";
      };
      mercurial = mkOption {
          default = true;
          description = "Enable mercurial repositories.";
      };
      subversion = mkOption {
          default = true;
          description = "Enable subversion repositories.";
      };
  };

  extraConfig = ''
      DocumentRoot ${phabricatorRoot}/phabricator/webroot

      RewriteEngine on
      RewriteRule ^/rsrc/(.*) - [L,QSA]
      RewriteRule ^/favicon.ico - [L,QSA]
      RewriteRule ^(.*)$ /index.php?__path__=$1 [B,L,QSA]
  '';

  extraServerPath = [
      "${pkgs.which}"
      "${pkgs.diffutils}"
      ] ++
      (if config.mercurial then ["${pkgs.mercurial}"] else []) ++
      (if config.subversion then ["${pkgs.subversion.out}"] else []) ++
      (if config.git then ["${pkgs.git}"] else []);

  startupScript = pkgs.writeScript "activatePhabricator" ''
      mkdir -p /var/repo
      chown wwwrun /var/repo
  '';

}
