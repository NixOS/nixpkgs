import ./make-test-python.nix (
  { ... }:
  {
    name = "dsym";

    nodes.machine =
      { ... }:
      {

        programs.dsym = {
          enable = true;
          #machineName = "test-machine";
          dotfileRepo = "https://github.com/example/dotfiles";
          dotfilePath = "/home/testuser/.config/";
          dsymPath = "/home/testuser/dsym/";
        };

        users.users.testuser = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          password = "test";
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("test -f /etc/dsym/config.ini")
      machine.succeed("grep 'dotfile_repo = https://github.com/example/dotfiles' /etc/dsym/config.ini")
      machine.succeed("grep 'dotfile_path = /home/testuser/.config/' /etc/dsym/config.ini")
      machine.succeed("grep 'dsym_path = /home/testuser/dsym/' /etc/dsym/config.ini")
    '';
  }
)
