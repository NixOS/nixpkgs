{ config, lib, ... }:

with lib;

let
  pkgs = config.nixpkgs.pkgs;

  profile = pkgs.stdenv.mkDerivation {
    name = "nixup-profile";
    preferLocalBuild = true;
    buildCommand = ''
      mkdir $out

      ${config.user.buildCommands}
    '';
  };

in

{
  options = {
    user.build = mkOption {
      internal = true;
      type = types.attrsOf types.package;
      default = {};
      description = ''
        Attribute set of derivations used to setup the system.
      '';
    };

    user.buildCommands = mkOption {
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

    user.build.profile = profile;

  };
}
