{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.environment.xdg;

  mimeTypeOpts = { name, config, ... }: {
    options = {

      name = mkOption {
        type = types.str;
        description = ''
           The name of the mime-type. If undefined, the name of the
           attribute set will be used.
        '';
      };

      comment = mkOption {
        type = types.loaOf types.str;
        description = ''
           The localized descriptions of the types.
        '';
      };

      sub-class-of = mkOption {
        type = types.str;
        description = ''
          The mime type name that this is a sub-class of.
        '';
      };

      globs = mkOption {
        type = types.listOf types.str;
        description = ''
          The list of patterns that this file can match.
        '';
      };

      alias = mkOption {
        type = types.str;
        description = "Alias of this type";
        default = "";
      };

      magic = mkOption {
        type = types.listOf types.optionSet;
        default = [];
        description = ''
          The identifying bits that identifies a files contents.
        '';
      };
    };
    config = mkMerge [ { name = mkDefault name; } ];
  };

  spec = pkgs.writeText "xdg-mime-types.json" (builtins.toJSON {
    types = mapAttrsToList (n: t:
      { inherit (t)
          name comment sub-class-of globs alias magic;
      }) cfg.mimeTypes;
  });

  match = {}: {};

in
{

  ##### interface

  options.environment.xdg = {
    mimeTypes = mkOption {
      default = {};
      type = types.loaOf types.optionSet;
      example = {
        "audio/ogg" = {
          comment = {
            "en" = "Ogg Audio";
            "de" = "Ogg-Audio";
          };
          sub-class-of = "application/ogg";
          globs = [ "*.oga" "i*.ogg" ".*opus" ];
          alias = "audio/x-ogg";
          magic = [
            match { value="OggS"; type="string"; offset="0"; }
          ];
        };
      };
      description = ''
        Custom mime-types to be created.
      '';
      options = [ mimeTypeOpts ];
    };
  };

  ##### implementation

  config = {

    environment.systemPackages = [
      (pkgs.stdenv.mkDerivation {
        src = spec;
        name = "nix-mimetypes";
        builder = pkgs.writeText "builder.sh" ''
           ${pkgs.coreutils}/bin/mkdir -p $out/share/mime/packages
           ${pkgs.perl}/bin/perl -w \
             -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl \
             -I${pkgs.perlPackages.JSON}/lib/perl5/site_perl \
             ${./update-mime-pkg.pl} ${spec} "$out"
        '';
      })
    ];
  };
}

