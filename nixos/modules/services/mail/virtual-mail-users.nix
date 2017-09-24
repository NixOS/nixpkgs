{ config, lib, pkgs, ... }:

with lib;
let 
  userOptions = import ./virtual-mail-submodule.nix;
  virtualMailEnv = pkgs.buildEnv {
    name = "virtualMail-env";
    paths = [];
    postBuild = let
      quotaRule = q: if q == "" then "" else "userdb_quota_rule=*";
      bytes = q: if q == "" then "" else "bytes=${q}";
      passwdLine = { name, domain, password, quota, ... }: { domain = "${domain}"; line = name + ":" + password + ":::::${quotaRule quota}:${bytes quota}"; }; 
      lines = map passwdLine config.services.mailUsers.users;
      domains = catAttrs "domain" lines;
      values = domain: catAttrs "line" (filter (x: x.domain == domain) lines);
      fileContent = domain: concatStringsSep "\n" (values domain);
      lnDomainFile = domain: "ln -sf ${pkgs.writeText domain (fileContent domain)} $out/${domain}";
    in concatStringsSep " && " (map lnDomainFile domains);
  };

in {
  options.services.mailUsers = {
    users = mkOption {
      type = types.listOf (types.submodule userOptions);
      example = [ { name = "js"; domain = "nixcloud.io"; password="qwertz"; } ];
      default = [];
      description = "A list of virtual mail users for which the password is managed via this abstraction";
    };
    virtualMailEnv = mkOption {
      default = virtualMailEnv;
      description = "Passwords are stored in the nix store and this virtual environment is a directory with those";
    };
  };

  config = {
    services.postfix.virtual = concatStringsSep "\n" (flatten (map (x: map (alias: alias + " " + x.name + "@" + x.domain) x.aliases) config.services.mailUsers.users
                             ++ map (user: map (d: "@${d} ${user.name}@${user.domain}") user.catchallFor) config.services.mailUsers.users));
    users.groups.virtualMail = { members = [ "dovecot2" ];};
    users.users.virtualMail = {
      home = "/var/lib/virtualMail";
      createHome = true;
    };
  };
}
