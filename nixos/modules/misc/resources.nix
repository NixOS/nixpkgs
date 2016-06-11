{ config, lib, pkgs, ... }:

with lib;

let

  resourceOpt = { name, config, ... }: {
    options = {

      allowCollisions = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If collissions are fine set to true
        '';
      };

      required_by = mkOption {
        type = mkOptionType {
          name = "required_by";
          check = isString;
          merge = loc: defs: defs;
        };

        description = ''
          Talks about what is requiring this resource. This helps the collision faster
        '';
      };
    };
  };

  assertions_for = rname:
    let cfg = config.resources.${rname};
    in

      foldl (assertions: name:
        let c = cfg."${name}";
            requires_to_str = xs: lib.concatStringsSep ", " (map (x: "${x.value} defined at ${x.file}" ) xs);
        in if
            name != "type"
           && builtins.length c.required_by > 1
           && !c.allowCollisions
        then [{
          assertion = false;
          message = "Resource ${rname} ${name} would be used multiple times by ${requires_to_str c.required_by}. Set config.resources.${rname}.${name}.allowCollisions = true to ignore.";
        }] ++ assertions else assertions
      ) []
      (attrNames cfg);

  t = description: {
    default = {};
    type = types.attrsOf types.optionSet;
    options = [ resourceOpt ];
    inherit description;
  };

in

{

  options = {

    resources.tcp-ports = mkOption (t "used tcp ports" // {
      example = {
        "80".required_by = "apache";
        "8080".required_by = "tomcat";
      };
    });

    resources.udp-ports = mkOption (t "used udp ports");

    resources.paths = mkOption (t "used ptahs" // {
      example = {
        "/tmp/mysql.socket".required_by = "mysql";
      };
    });

    resources.uids = mkOption (t "used uids");
    resources.gids = mkOption (t "used gids");
  };

  config = {

    assertions =
         assertions_for "tcp-ports"
      ++ assertions_for "udp-ports"
      ++ assertions_for "paths"
      ++ assertions_for "uids"
      ++ assertions_for "gids"
    ;

  };

}
