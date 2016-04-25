{ config, lib, pkgs, ... }:

# Flying Circus user management
#
# UID ranges
#
# 30.000 - 30.999: reserved for nixbldXX and NixOS stuff
# 31.000 - 65.534: reserved for Flying Circus-specific system user
#
#
# GID ranges
#
# 30.000 - 31.000: reserved for NixOS-specific stuff
# 31.000 - 65.534: reserved for Flying Circus-specific system groups

let

  cfg = config.flyingcircus;

  userdata =
    if builtins.pathExists cfg.userdata_path
    then builtins.fromJSON (builtins.readFile cfg.userdata_path)
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
          hashedPassword = lib.removePrefix "{CRYPT}" user.password;
          home = user.home_directory;
          shell = "/run/current-system/sw" + user.login_shell;
          uid = user.id;
          openssh.authorizedKeys.keys = user.ssh_pubkey;
        };
      })
      userdata);


  admins_group_data =
    if builtins.pathExists cfg.admins_group_path
    then builtins.fromJSON (builtins.readFile cfg.admins_group_path)
    else null;

  admins_group =
    if admins_group_data == null
    then {}
    else {
      ${admins_group_data.name}.gid = admins_group_data.gid;
    };

  current_rg =
    if lib.hasAttrByPath ["parameters" "resource_group"] cfg.enc
    then cfg.enc.parameters.resource_group
    else null;

  get_group_memberships_for_user = user:
    if current_rg != null && builtins.hasAttr current_rg user.permissions
    then
      lib.listToAttrs
        (map
          # making members a scalar here so that zipAttrs automatically joins
          # them but doesn't create a list of lists.
          (perm: { name = perm; value = { members = user.uid; }; })
          (builtins.getAttr current_rg user.permissions))
    else {};

  # user list from directory -> { groupname.members = [a b c], ...}
  get_group_memberships = users:
    lib.mapAttrs (name: groupdata: lib.zipAttrs groupdata)
      (lib.zipAttrs (map get_group_memberships_for_user users));

  permissions =
    if builtins.pathExists cfg.permissions_path
    then builtins.fromJSON (builtins.readFile cfg.permissions_path)
    else [];

  get_permission_groups = permissions:
    lib.listToAttrs
      (builtins.filter
        (group: group.name != "wheel")  # This group already exists
        (map
          (permission: {
            name = permission.name;
            value = {
              gid = config.ids.gids.${permission.name};
            };
          })
          permissions));

  home_dir_permissions = userdata:
    map
      (user: "install -d -m 0755 ${user.home_directory}")
      userdata;

  configure_lingering = userdata:
    # Service users should have lingering enabled
    map
      (user: " ${config.systemd.package}/bin/loginctl ${if (get_primary_group user) == "service" then "enable" else "disable"}-linger ${user.uid}")
      userdata;

in

{

  options = {

    flyingcircus.userdata_path = lib.mkOption {
      default = /etc/nixos/users.json;
      type = lib.types.path;
      description = ''
        Where to find the user json file.

        directory.list_users();
      '';
    };

    flyingcircus.admins_group_path = lib.mkOption {
      default = /etc/nixos/admins.json;
      type = lib.types.path;
      description = ''
        Where to find the admins group json file.

        directory.lookup_resourcegroup('admins')
      '';
    };

    flyingcircus.permissions_path = lib.mkOption {
      default = /etc/nixos/permissions.json;
      type = lib.types.path;
      description = ''
        Where to find the permissions json file.

        directory.list_permissions()
      '';
    };

  };


  config = {

    ids.uids = {

      # Our custom services
      sensuserver = 31001;
      sensuapi = 31002;
      uchiwa = 31003;
      sensuclient = 31004;
      powerdns = 31005;

    };

    ids.gids = {
      # The generic 'service' GID is different from Gentoo.
      # But 101 is already used in NixOS.
      service = 900;

      # Our permissions
      login = 500;
      code = 501;
      stats = 502;
      sudo-srv = 503;

      # Our custom services
      sensuserver = 31001;
      sensuapi = 31002;
      uchiwa = 31003;
      sensuclient = 31004;

    };

    security.pam.services.sshd.showMotd = true;
    security.pam.access = ''
    # Local logins are always fine. This is to unblock any automation like
    # systemd services
    + : ALL : LOCAL
    # Remote logins are restricted to admins and the login group.
    + : root (admins) (login): ALL
    # Other remote logins are not allowed.
    - : ALL : ALL
    '';

    users = {
      mutableUsers = false;
      users = map_userdata userdata;
      groups =
        get_permission_groups permissions
        // { service.gid = config.ids.gids.service; }
        // admins_group
        // get_group_memberships userdata;
    };

    # needs to be first in sudoers because of the %admins rule
    security.sudo.extraConfig = lib.mkBefore ''
      Defaults set_home,!authenticate,!mail_no_user
      Defaults lecture = never

      # Allow unrestricted access to super admins
      %admins ALL=(ALL) PASSWD: ALL

      ## Cmnd alias specification
      Cmnd_Alias  REBOOT = ${pkgs.systemd}/bin/systemctl reboot, \
            ${pkgs.systemd}/bin/systemctl poweroff

      %sudo-srv ALL=(%service) ALL
      %sudo-srv ALL=(root) REBOOT

      # Allow applying config and restarting services to service users
      Cmnd_Alias  FCMANAGE = ${pkgs.systemd}/bin/systemctl start fc-manage
      %sudo-srv ALL=(root) FCMANAGE
      %service  ALL=(root) FCMANAGE
    '';

    system.activationScripts.fcio-homedirpermissions =
      builtins.concatStringsSep "\n" (home_dir_permissions userdata);

    system.activationScripts.fcio-configure-lingering =
      builtins.concatStringsSep "\n" (configure_lingering userdata);

  };

}
