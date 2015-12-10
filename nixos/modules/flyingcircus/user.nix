{ config, lib, pkgs, ... }:

let

  userdata =
    if builtins.pathExists config.fcio.userdata_path
    then builtins.fromJSON (builtins.readFile config.fcio.userdata_path)
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


  admins_group_data =
    if builtins.pathExists config.fcio.admins_group_path
    then builtins.fromJSON (builtins.readFile config.fcio.admins_group_path)
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

  permissions =
    if builtins.pathExists config.fcio.permissions_path
    then builtins.fromJSON (builtins.readFile config.fcio.permissions_path)
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

  options = {

    fcio.userdata_path = lib.mkOption {
      default = /etc/nixos/users.json;
      type = lib.types.path;
      description = ''
        Where to find the user json file.

        directory.list_users();
      '';
    };

    fcio.admins_group_path = lib.mkOption {
      default = /etc/nixos/admins.json;
      type = lib.types.path;
      description = ''
        Where to find the admins group json file.

        directory.lookup_resourcegroup('admins')
      '';
    };

    fcio.permissions_path = lib.mkOption {
      default = /etc/nixos/permissions.json;
      type = lib.types.path;
      description = ''
        Where to find the permissions json file.

        directory.list_permissions()
      '';
    };

  };


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
