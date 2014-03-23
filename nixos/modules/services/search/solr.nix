{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.solr;

  # Assemble all jars needed for solr
  solrJars = pkgs.stdenv.mkDerivation {
    name = "solr-jars";

    src = pkgs.fetchurl {
      url = http://archive.apache.org/dist/tomcat/tomcat-5/v5.5.36/bin/apache-tomcat-5.5.36.tar.gz;
      sha256 = "01mzvh53wrs1p2ym765jwd00gl6kn8f9k3nhdrnhdqr8dhimfb2p";
    };

    buildPhases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/lib
      cp common/lib/*.jar $out/lib/
      ln -s ${pkgs.ant}/lib/ant/lib/ant.jar $out/lib/
      ln -s ${cfg.solrPackage}/lib/ext/* $out/lib/
      ln -s ${pkgs.openjdk}/lib/openjdk/lib/tools.jar $out/lib/
    '';
  };

in {

  options = {
    services.solr = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the solr service.
        '';
      };

      javaPackage = mkOption {
        type = types.package;
        default = pkgs.openjre;
        description = ''
          Which Java derivation to use for running solr.
        '';
      };

      solrPackage = mkOption {
        type = types.package;
        default = pkgs.solr;
        description = ''
          Which solr derivation to use for running solr.
        '';
      };

      log4jConfiguration = mkOption {
        type = types.lines;
        default = ''
          log4j.rootLogger=INFO, stdout
          log4j.appender.stdout=org.apache.log4j.ConsoleAppender
          log4j.appender.stdout.Target=System.out
          log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
          log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n
        '';
        description = ''
          Contents of the <literal>log4j.properties</literal> used. By default,
          everything is logged to stdout (picked up by systemd) with level INFO.
        '';
      };

      user = mkOption {
        type = types.str;
        description = ''
          The user that should run the solr process and.
          the working directories.
        '';
      };

      group = mkOption {
        type = types.str;
        description = ''
          The group that will own the working directory.
        '';
      };

      solrHome = mkOption {
        type = types.str;
        description = ''
          The solr home directory. It is your own responsibility to
          make sure this directory contains a working solr configuration,
          and is writeable by the the user running the solr service.
          Failing to do so, the solr will not start properly.
        '';
      };

      extraJavaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra command line options given to the java process running
          solr.
        '';
      };

      extraWinstoneOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra command line options given to the Winstone, which is
          the servlet container hosting solr.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.winstone.solr = {
      serviceName = "solr";
      inherit (cfg) user group javaPackage;
      warFile = "${cfg.solrPackage}/lib/solr.war";
      extraOptions = [
        "--commonLibFolder=${solrJars}/lib"
        "--useJasper"
      ] ++ cfg.extraWinstoneOptions;
      extraJavaOptions = [
        "-Dsolr.solr.home=${cfg.solrHome}"
        "-Dlog4j.configuration=file://${pkgs.writeText "log4j.properties" cfg.log4jConfiguration}"
      ] ++ cfg.extraJavaOptions;
    };

  };

}
