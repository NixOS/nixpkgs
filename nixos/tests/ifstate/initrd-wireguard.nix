let
  mkNodeIfStateConfig =
    {
      pkgs,
      id,
      wgPriv,
      wgPeerPubKey,
      wgPeerId,
    }:
    {
      enable = true;
      settings = {
<<<<<<< HEAD
        namespaces.outside.interfaces.eth1 = {
          addresses = [ "2001:0db8:a::${builtins.toString id}/64" ];
          link = {
            state = "up";
            kind = "physical";
          };
        };
        interfaces = {
=======
        interfaces = {
          eth1 = {
            addresses = [ "2001:0db8:a::${builtins.toString id}/64" ];
            link = {
              state = "up";
              kind = "physical";
            };
          };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          wg0 = {
            addresses = [ "2001:0db8:b::${builtins.toString id}/64" ];
            link = {
              state = "up";
              kind = "wireguard";
<<<<<<< HEAD
              bind_netns = "outside";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
in
{
  name = "ifstate-initrd-wireguard";

  nodes = {
    foo =
      { pkgs, ... }:
      {
        imports = [ ../../modules/profiles/minimal.nix ];

        virtualisation.interfaces.eth1.vlan = 1;

        # Initrd IfState enforces stage 2 ifstate using assertion.
        networking.ifstate = {
          enable = true;
          settings.interfaces = { };
        };

        boot.initrd = {
<<<<<<< HEAD
          # otherwise the interfaces do not get created
          kernelModules = [ "virtio_net" ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          network = {
            enable = true;
            ifstate =
              mkNodeIfStateConfig {
                inherit pkgs;
                id = 1;
                wgPriv = "6KmLyTyrN9OZIOCkdpiAwoVoeSiwvyI+mtn1wooKSEU=";
                wgPeerPubKey = "olFuE7u5pVwSeWLFtrXSvD8+aCDBiKNKCLjLb/dgXiA=";
                wgPeerId = 2;
              }
              // {
<<<<<<< HEAD
                allowIfstateToDrasticlyIncreaseInitrdSize = true;
              };
          };

=======
                package = pkgs.ifstate.override {
                  withConfigValidation = false;
                };
                allowIfstateToDrasticlyIncreaseInitrdSize = true;
              };
          };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

    bar =
      { pkgs, ... }:
      {
        imports = [ ../../modules/profiles/minimal.nix ];

        virtualisation.interfaces.eth1.vlan = 1;

        networking = {
          ifstate = mkNodeIfStateConfig {
            inherit pkgs;
            id = 2;
            wgPriv = "QN89cvFD0C8z1MSpUaJa1YBXt2MaIQegVkEYROi71Fg=";
            wgPeerPubKey = "5qeKbAGc7wh9Xg0MoMXqXCSmp9TawmtI1bVk/vp3Cn4=";
            wgPeerId = 1;
          };
        };
      };
  };
  testScript = # python
    ''
      start_all()

      bar.wait_for_unit("default.target")

      bar.wait_until_succeeds("ping -c 1 2001:0db8:b::1")
    '';
}
