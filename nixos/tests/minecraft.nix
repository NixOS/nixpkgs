import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "minecraft";
  meta = with lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.client = { nodes, ... }:
      let user = nodes.client.config.users.users.alice;
      in {
        imports = [ ./common/user-account.nix ./common/x11.nix ];

        environment.systemPackages = [ pkgs.minecraft ];

        nixpkgs.config.allowUnfree = true;

        test-support.displayManager.auto.user = user.name;
      };

  enableOCR = true;

  testScript = { nodes, ... }:
    let user = nodes.client.config.users.users.alice;
    in ''
      client.wait_for_x()
      client.execute("su - alice -c minecraft-launcher >&2 &")
      client.wait_for_text("Create a new Microsoft account")
      client.sleep(10)
      client.screenshot("launcher")
    '';
})
