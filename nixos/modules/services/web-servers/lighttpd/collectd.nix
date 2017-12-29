{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lighttpd.collectd;

  collectionConf = pkgs.writeText "collection.conf" ''
    datadir: "${config.services.collectd.dataDir}"
    libdir: "${config.services.collectd.package}/lib/collectd"
  '';

  defaultCollectionCgi = config.services.collectd.package.overrideDerivation(old: {
    name = "collection.cgi";
    configurePhase = "true";
    buildPhase = "true";
    installPhase = ''
      substituteInPlace contrib/collection.cgi --replace '"/etc/collection.conf"' '$ENV{COLLECTION_CONF}'
      cp contrib/collection.cgi $out
    '';
  });
in
{

  options.services.lighttpd.collectd = {

    enable = mkEnableOption "collectd subservice accessible at http://yourserver/collectd";

    collectionCgi = mkOption {
      type = types.path;
      default = defaultCollectionCgi;
      description = ''
        Path to collection.cgi script from (collectd sources)/contrib/collection.cgi
        This option allows to use a customized version
      '';
    };
  };

  config = mkIf cfg.enable {
    services.lighttpd.enableModules = [ "mod_cgi" "mod_alias" "mod_setenv" ];

    services.lighttpd.extraConfig = ''
      $HTTP["url"] =~ "^/collectd" {
        cgi.assign = (
          ".cgi" => "${pkgs.perl}/bin/perl"
        )
        alias.url = (
          "/collectd" => "${cfg.collectionCgi}"
        )
        setenv.add-environment = (
          "PERL5LIB" => "${with pkgs; lib.makePerlPath [ perlPackages.CGI perlPackages.HTMLParser perlPackages.URI rrdtool ]}",
          "COLLECTION_CONF" => "${collectionConf}"
        )
      }
    '';
  };

}
