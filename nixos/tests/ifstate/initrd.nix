let
  mkIfStateConfig = id: {
    enable = true;
    settings.interfaces.eth1 = {
      addresses = [ "2001:0db8::${builtins.toString id}/64" ];
      link = {
        state = "up";
        kind = "physical";
      };
    };
  };
in
{
  name = "ifstate-initrd";

  nodes = {
    server = {
      imports = [ ../../modules/profiles/minimal.nix ];

      virtualisation.interfaces.eth1.vlan = 1;

      # Initrd IfState enforces stage 2 ifstate using assertion.
      networking.ifstate = {
        enable = true;
        settings.interfaces = { };
      };

      boot.initrd = {
        network = {
          enable = true;
          ifstate = mkIfStateConfig 1 // {
            allowIfstateToDrasticlyIncreaseInitrdSize = true;
          };
        };
        systemd = {
          enable = true;
          network.enable = false;
          services.boot-blocker = {
            before = [ "initrd.target" ];
            wantedBy = [ "initrd.target" ];
            script = "sleep infinity";
            serviceConfig.Type = "oneshot";
          };
        };
      };
    };

    client = {
      imports = [ ../../modules/profiles/minimal.nix ];

      virtualisation.interfaces.eth1.vlan = 1;

      networking.ifstate = mkIfStateConfig 2;
    };
  };

  testScript = # python
    ''
      start_all()
      client.wait_for_unit("network.target")

      # try to ping the server from the client
      client.wait_until_succeeds("ping -c 1 2001:0db8::1")
    '';
}
