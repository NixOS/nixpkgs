# Test the etc modules file cleanup.

import ./make-test-python.nix ( { ... } : {
  name = "etc-cleanup";
  meta = {
    maintainers = [ ];
  };

  nodes =
    { initial =
        { ... }:
        {
          environment.etc = {
            "remove" = {
              # this symlink should be removed after switching
              text = "remove";
            };

            "change" = {
              # this symlinks contents should change after switching
              text = "previous";
            };

            "persist" = {
              # this symlinks contents should stay the same after switching
              text = "persist";
            };

            # test direct symlinks get updated
            # non direct symlinks dont need to be updated as the point to /etc/static/*
            # which contains the updated files after a rebuild, however direct symlinks dont have this indirection
            "direct-change" = {
              text = "state1";
              mode = "direct-symlink";
            };
          };
        };

      # Dummy configuration to check whether firewall.service will be honored
      # during system activation. This only needs to be different to the
      # original walled configuration so that there is a change in the service
      # file.
      swap =
        { ... }:
        {
          environment.etc = {
            "created" = {
              # this symlink should be added after switching
              text = "created";
            };

            "change" = {
              text = "next";
            };

            "persist" = {
              text = "persist";
            };

            "direct-change" = {
              text = "state2";
              mode = "direct-symlink";
            };
          };
        };
    };

  testScript = { nodes, ... }: let
    newSystem = nodes.swap.system.build.toplevel;
  in ''
    # wait for startup
    initial.wait_for_file("/etc/remove")

    # test that symlinks get created
    initial.succeed("test -L /etc/remove")
    initial.succeed("test -L /etc/change")
    initial.succeed("test -L /etc/persist")

    # test that symlinks that get added after switching
    # are not already present
    initial.succeed("test ! -L /etc/added")

    initial.succeed("test -L /etc/direct-change")
    initial.succeed("grep state1 /etc/direct-change")

    # switch
    initial.succeed("${newSystem}/bin/switch-to-configuration test")

    # test that the expected changes happend

    # test for removal
    initial.succeed("test ! -L /etc/remove")

    # test for creation
    initial.succeed("test -L /etc/created")
    initial.succeed("grep 'created' /etc/created")

    # test for persistence
    initial.succeed("test -L /etc/persist")
    initial.succeed("grep 'persist' /etc/persist")

    # test for modification
    initial.succeed("test -L /etc/change")
    initial.succeed("grep 'next' /etc/change")

    # test direct-symlink
    initial.succeed("test -L /etc/direct-change")
    initial.succeed("grep state2 /etc/direct-change")
  '';
})
