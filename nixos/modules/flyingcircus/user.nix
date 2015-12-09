{ config, lib, pkgs, ... }:

let

  # `list_users()`
  userdata_path = /etc/nixos/users.json;
  userdata =
    if builtins.pathExists userdata_path
    then builtins.fromJSON (builtins.readFile userdata_path)
    else [];

  get_primary_group = user:
    builtins.getAttr user.class {
      human = "users";
      service = "service";
    };

  # Data read from Directory (list) -> users.users structure (list)
  map_userdata = userdata:
  lib.listToAttrs
    (map
      (user: {
        name = user.uid;
        value = {
          # extraGroups = ["wheel"];
          createHome = true;
          description = user.name;
          group = get_primary_group user;
          hashedPassword = user.password;
          home = user.home_directory;
          shell = "/run/current-system/sw" + user.login_shell;
          uid = user.id;
          openssh.authorizedKeys.keys = user.ssh_pubkey;
        };
      })
      userdata);

  # `list_permissions()`
  permissions_path = /etc/nixos/permissions.json;
  permissions =
    if builtins.pathExists permissions_path
    then builtins.fromJSON (builtins.readFile permissions_path)
    else [];

  get_permission_groups = permissions:
    lib.listToAttrs
      (builtins.filter
        (group: group.name != "wheel")  # This group already exists
        (map
          (permission: {
            name = permission.name;
            value = {
              gid = permission.id;
            };
          })
          permissions));

in
{
  config = {

    ids.gids = {
      # This is different from Gentoo. But 101 is already used in
      service = 900;
    };

    security.pam.services.sshd.showMotd = true;
    users = {
      motd = "Welcome to the Flying Circus";

      users = map_userdata userdata;

      groups = {
        service.gid = config.ids.gids.service;
      } // get_permission_groups permissions;
    };
  };
}
