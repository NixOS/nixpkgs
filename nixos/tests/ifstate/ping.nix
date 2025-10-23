let
  mkNode = id: {
    imports = [ ../../modules/profiles/minimal.nix ];

    virtualisation.interfaces.eth1.vlan = 1;

    networking.ifstate = {
      enable = true;
      settings.interfaces.eth1 = {
        addresses = [ "2001:0db8::${builtins.toString id}/64" ];
        link = {
          state = "up";
          kind = "physical";
        };
      };
    };
  };
in

{
  name = "ifstate-ping";

  nodes = {
    foo = mkNode 1;
    bar = mkNode 2;
  };

  testScript = # python
    ''
      start_all()

      foo.wait_for_unit("default.target")
      bar.wait_for_unit("default.target")

      foo.wait_until_succeeds("ping -c 1 2001:0db8::2")
      bar.wait_until_succeeds("ping -c 1 2001:0db8::1")
    '';
}
