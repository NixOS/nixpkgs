{ config, lib, pkgs, ... }:

with lib;

let

  profile = pkgs.stdenv.mkDerivation {
    name = "nixup-profile";
    preferLocalBuild = true;
    buildCommand = ''
      mkdir $out

      ${config.nixup.buildCommands}
    '';
  };

in

{
  options = {
    nixup.build = mkOption {
      internal = true;
      type = types.attrsOf types.package;
      default = {};
      description = ''
        Attribute set of derivations used to setup the system.
      '';
    };

    nixup.buildCommands = mkOption {
      internal = true;
      type = types.lines;
      default = [];
      example = literalExample ''
        "ln -s ${pkgs.firefox} $out/firefox-stable"
     '';
      description = ''
        List of commands to build and install the content of the profile
        directory.
      '';
    };
  };

  config = {

    nixup.build.profile = profile;

  };
}
