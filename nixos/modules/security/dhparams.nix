{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.dhparams;

  idString = "${config.networking.hostName}-${toString config.networking.hostId}";

  inherit (pkgs) openssl;

  dhparamOpts = { ... }: {
    options = {
      bits = mkOption {
        type = types.int;
        default = 4096;
        description = "Number of bits for Diffie-Hellman parameters length";
      };
    };
  };

in

{

  options = {
    security.dhparams = mkOption {
      default = { };
      type = types.loaOf types.optionSet;
      description = ''
        Attribute set or list of paths relative to /etc to place Diffie-Hellman
        parameters that should be generated. Defaults to 4096 bits.
      '';
      options = [ dhparamOpts ];
      example = {
        "nginx/dhparam.pem".bits = 4096;
        "prosody/dhparam.pem" = {};
      };
    };
  };

  config = {
    environment.etc = flip mapAttrs' cfg (path: data: nameValuePair
      (path)
      ({ source = pkgs.runCommand "dhparam-${idString}-${replaceStrings ["/"] ["-"] path}" {}
           "${openssl}/bin/openssl dhparam -out $out ${toString data.bits}";
      })
    );
  };

}
