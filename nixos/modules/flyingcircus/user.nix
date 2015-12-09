{ config, lib, pkgs, ... }:

let

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
          shell = user.login_shell;
          uid = user.id;
          openssh.authorizedKeys.keys = user.ssh_pubkey;
        };
      })
      userdata);

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
      };
    };
  };
}
