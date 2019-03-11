{pkgs, config, lib, ...}:

let
  inherit (lib) mkOption mkIf types length attrNames;
  cfg = config.services.kerberos_server;
  kerberos = config.krb5.kerberos;

  aclEntry = {
    options = {
      principal = mkOption {
        type = types.str;
        description = "Which principal the rule applies to";
      };
      access = mkOption {
        type = types.either
          (types.listOf (types.enum ["add" "cpw" "delete" "get" "list" "modify"]))
          (types.enum ["all"]);
        default = "all";
        description = "The changes the principal is allowed to make.";
      };
      target = mkOption {
        type = types.str;
        default = "*";
        description = "The principals that 'access' applies to.";
      };
    };
  };

  realm = {
    options = {
      acl = mkOption {
        type = types.listOf (types.submodule aclEntry);
        default = [
          { principal = "*/admin"; access = "all"; }
          { principal = "admin"; access = "all"; }
        ];
        description = ''
          The privileges granted to a user.
        '';
      };
    };
  };
in

{
  imports = [
    ./mit.nix
    ./heimdal.nix
  ];

  ###### interface
  options = {
    services.kerberos_server = {
      enable = mkOption {
        default = false;
        description = ''
          Enable the kerberos authentification server.
        '';
      };

      realms = mkOption {
        type = types.attrsOf (types.submodule realm);
        description = ''
          The realm(s) to serve keys for.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ kerberos ];
    assertions = [{
      assertion = length (attrNames cfg.realms) <= 1;
      message = "Only one realm per server is currently supported.";
    }];
  };
}
