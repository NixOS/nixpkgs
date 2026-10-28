{
  name = "ifstate-partial-broken-config";

  nodes.machine = {
    imports = [ ../../modules/profiles/minimal.nix ];

    virtualisation.interfaces.eth1.vlan = 1;

    networking.ifstate = {
      enable = true;
      settings.interfaces = {
        eth1 = {
          addresses = [ "2001:0db8:a::1/64" ];
          link = {
            state = "up";
            kind = "physical";
          };
        };
        # non-existent interface; ifstate should apply eth1 and do not distrupt the boot process
        eth2 = {
          addresses = [ "2001:0db8:b::1/64" ];
          link = {
            state = "up";
            kind = "physical";
          };
        };
      };
    };
  };

  testScript = # python
    ''
      start_all()

      machine.wait_for_unit("default.target")

      machine.wait_until_succeeds("ping -c 1 2001:0db8:a::1")
    '';
}
