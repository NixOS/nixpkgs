import ./make-test-python.nix ({ lib, ... }:
{
  name = "please";
  meta.maintainers = with lib.maintainers; [ azahi ];

  nodes.machine =
    { ... }:
    {
      users.users = with lib; mkMerge [
        (listToAttrs (map
          (n: nameValuePair n { isNormalUser = true; })
          (genList (x: "user${toString x}") 6)))
        {
          user0.extraGroups = [ "wheel" ];
        }
      ];

      security.please = {
        enable = true;
        wheelNeedsPassword = false;
        settings = {
          user2_run_true_as_root = {
            name = "user2";
            target = "root";
            rule = "/run/current-system/sw/bin/true";
            require_pass = false;
          };
          user4_edit_etc_hosts_as_root = {
            name = "user4";
            type = "edit";
            target = "root";
            rule = "/etc/hosts";
            editmode = 644;
            require_pass = false;
          };
        };
      };
    };

  testScript = ''
    with subtest("root: can run anything by default"):
        machine.succeed('please true')
    with subtest("root: can edit anything by default"):
        machine.succeed('EDITOR=cat pleaseedit /etc/hosts')

    with subtest("user0: can run as root because it's in the wheel group"):
        machine.succeed('su - user0 -c "please -u root true"')
    with subtest("user1: cannot run as root because it's not in the wheel group"):
        machine.fail('su - user1 -c "please -u root true"')

    with subtest("user0: can edit as root"):
        machine.succeed('su - user0 -c "EDITOR=cat pleaseedit /etc/hosts"')
    with subtest("user1: cannot edit as root"):
        machine.fail('su - user1 -c "EDITOR=cat pleaseedit /etc/hosts"')

    with subtest("user2: can run 'true' as root"):
        machine.succeed('su - user2 -c "please -u root true"')
    with subtest("user3: cannot run 'true' as root"):
        machine.fail('su - user3 -c "please -u root true"')

    with subtest("user4: can edit /etc/hosts"):
        machine.succeed('su - user4 -c "EDITOR=cat pleaseedit /etc/hosts"')
    with subtest("user5: cannot edit /etc/hosts"):
        machine.fail('su - user5 -c "EDITOR=cat pleaseedit /etc/hosts"')
  '';
})
