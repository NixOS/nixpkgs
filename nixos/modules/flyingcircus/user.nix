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

  # `lookup_resourcegroup('admins')
  admins_group_path = /etc/nixos/admins.json;
  admins_group_data =
    if builtins.pathExists admins_group_path
    then builtins.fromJSON (builtins.readFile admins_group_path)
    else null;
  admins_group =
    if admins_group_data == null
    then {}
    else {
      ${admins_group_data.name}.gid = admins_group_data.gid;
    };

  current_rg =
    if lib.hasAttrByPath ["parameters" "resource_group"] config.fcio.enc
    then config.fcio.enc.parameters.resource_group
    else null;

  get_group_memberships_for_user = user:
    if current_rg != null && builtins.hasAttr current_rg user.permissions
    then
      lib.listToAttrs
        (map
          (perm: { name = perm; value = { members = [user.uid]; }; })
          (builtins.getAttr current_rg user.permissions))
    else {};

  # user list from directory -> { groupname.members = [a b c], ...}
  get_group_memberships = users:
    if users == []
    then {}
    else
      get_group_memberships_for_user (builtins.head users) //
      get_group_memberships (builtins.tail users);

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
      mutableUsers = false;
      users = map_userdata userdata;
      groups =
        get_permission_groups permissions
        // { service.gid = config.ids.gids.service; }
        // admins_group
        // get_group_memberships userdata;
    };
  };
}
