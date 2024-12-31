# This module provides JAVA_HOME, with a different way to install java
# system-wide.

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.java;
in
{

  options = {

    programs.java = {

      enable = lib.mkEnableOption "java" // {
        description = ''
          Install and setup the Java development kit.

          ::: {.note}
          This adds JAVA_HOME to the global environment, by sourcing the
          jdk's setup-hook on shell init. It is equivalent to starting a shell
          through 'nix-shell -p jdk', or roughly the following system-wide
          configuration:

              environment.variables.JAVA_HOME = ''${pkgs.jdk.home}/lib/openjdk;
              environment.systemPackages = [ pkgs.jdk ];
          :::
        '';
      };

      package = lib.mkPackageOption pkgs "jdk" {
        example = "jre";
      };

      binfmt = lib.mkEnableOption "binfmt to execute java jar's and classes";

    };

  };

  config = lib.mkIf cfg.enable {

    boot.binfmt.registrations = lib.mkIf cfg.binfmt {
      java-class = {
        recognitionType = "extension";
        magicOrExtension = "class";
        interpreter = pkgs.writeShellScript "java-class-wrapper" ''
          test -e ${cfg.package}/nix-support/setup-hook && source ${cfg.package}/nix-support/setup-hook
          classpath=$(dirname "$1")
          class=$(basename "''${1%%.class}")
          $JAVA_HOME/bin/java -classpath "$classpath" "$class" "''${@:2}"
        '';
      };
      java-jar = {
        recognitionType = "extension";
        magicOrExtension = "jar";
        interpreter = pkgs.writeShellScript "java-jar-wrapper" ''
          test -e ${cfg.package}/nix-support/setup-hook && source ${cfg.package}/nix-support/setup-hook
          $JAVA_HOME/bin/java -jar "$@"
        '';
      };
    };

    environment.systemPackages = [ cfg.package ];

    environment.shellInit = ''
      test -e ${cfg.package}/nix-support/setup-hook && source ${cfg.package}/nix-support/setup-hook
    '';

  };

}
