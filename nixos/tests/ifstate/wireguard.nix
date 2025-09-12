let
  mkNode =
    {
      id,
      wgPriv,
      wgPeerPubKey,
      wgPeerId,
    }:
    (
      { pkgs, ... }:
      {
        imports = [ ../../modules/profiles/minimal.nix ];

        virtualisation.interfaces.eth1.vlan = 1;

        networking = {
          firewall.interfaces.eth1.allowedUDPPorts = [ 51820 ];

          ifstate = {
            enable = true;
            settings = {
              namespaces.outside.interfaces.eth1 = {
                addresses = [ "2001:0db8:a::${builtins.toString id}/64" ];
                link = {
                  state = "up";
                  kind = "physical";
                };
              };
              interfaces = {
                wg0 = {
                  addresses = [ "2001:0db8:b::${builtins.toString id}/64" ];
                  link = {
                    state = "up";
                    kind = "wireguard";
                    bind_netns = "outside";
                  };
                  wireguard = {
                    private_key = "!include ${pkgs.writeText "wg_priv.key" wgPriv}";
                    listen_port = 51820;
                    peers."${wgPeerPubKey}" = {
                      endpoint = "[2001:0db8:a::${builtins.toString wgPeerId}]:51820";
                      allowedips = [ "::/0" ];
                    };
                  };
                };
              };
              routing.routes = [
                {
                  to = "2001:0db8:b::/64";
                  dev = "wg0";
                }
              ];
            };
          };
        };
      }
    );
in

{
  name = "ifstate-wireguard";

  nodes = {
    foo = mkNode {
      id = 1;
      wgPriv = "6KmLyTyrN9OZIOCkdpiAwoVoeSiwvyI+mtn1wooKSEU=";
      wgPeerPubKey = "olFuE7u5pVwSeWLFtrXSvD8+aCDBiKNKCLjLb/dgXiA=";
      wgPeerId = 2;
    };
    bar = mkNode {
      id = 2;
      wgPriv = "QN89cvFD0C8z1MSpUaJa1YBXt2MaIQegVkEYROi71Fg=";
      wgPeerPubKey = "5qeKbAGc7wh9Xg0MoMXqXCSmp9TawmtI1bVk/vp3Cn4=";
      wgPeerId = 1;
    };
  };

  testScript = # python
    ''
      start_all()

      foo.wait_for_unit("default.target")
      bar.wait_for_unit("default.target")

      foo.wait_until_succeeds("ping -c 1 2001:0db8:b::2")
      bar.wait_until_succeeds("ping -c 1 2001:0db8:b::1")
    '';
}
