# Test that the user generation from ENC works fine.

import ./make-test.nix ({ pkgs, ...} :

let



in

{
  name = "users";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ theuni ];
  };

  machine =
    { config, lib, pkgs, modulesPath, ... }:
    with lib;
    let
      admin_users_enc = pkgs.writeText "users.json" ''
      '';
    in
    {

      imports =
        ["${modulesPath}/flyingcircus/vm-base-profile.nix"];

      fcio.userdata = ''
    [{"login_shell": "/bin/bash", "uid": "bob", "home_directory": "/home/bob", "name": "Bob the Blob", "ssh_pubkey": ["ssh-rsa asdf bob"], "permissions": {"test": ["stats", "sudo-srv", "login", "admins"]}, "password": "{CRYPT}$6$FrY8Rmj2$asdffdsa", "gid": 100, "id": 1152, "class": "human"}]
'';
      swapDevices = mkOverride 0
        [ { device = "/root/swapfile"; size = 128; } ];
      environment.variables.EDITOR = mkOverride 0 "emacs";
      services.nixosManual.enable = mkOverride 0 true;
      systemd.tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
      fileSystems = mkVMOverride { "/tmp2" =
        { fsType = "tmpfs";
          options = "mode=1777,noauto";
        };
      };
      systemd.automounts = singleton
        { wantedBy = [ "multi-user.target" ];
          where = "/tmp2";
        };
    };


  testScript = ''

    $machine->waitForUnit("default.target");

    subtest "admin-user", sub {
      $machine->succeed("id bob");
      $machine->screenshot("asdf");
    };

  '';
})


