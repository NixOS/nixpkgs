import ./make-test.nix ({ pkgs, ...} : {
  name = "initial-home-contents";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bobvanderlinden ];
  };

  nodes = {
    machine = { config, lib, pkgs, ... }: {
      users.users.testuser = {
        isNormalUser = true;
        home = "/home/testuser";
        initialHomeContents = pkgs.runCommand "homecontent" {} ''
          mkdir -p $out/new-directory
          touch $out/new-file
        '';
      };
    };
  };

  testScript = {nodes, ...}: ''
    $machine->start();
    $machine->waitForUnit("default.target");

    $machine->succeed("test -d /home/testuser/new-directory");
    $machine->succeed("test -f /home/testuser/new-file");
  '';
})
