import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "container-tests";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.server = { pkgs, lib, ... }: {
    nixos.containers.instances = {
      container0 = {
        nixpkgs = builtins.fetchTarball "https://github.com/Ma27/nixpkgs/archive/88661bfb6443d0269fbab35b773ca9b9d469d8ba.tar.gz";
        network = {
        };
      };
      container1 = {
        sharedNix = false;
        nixpkgs = ../..;
        zone = "foo";
        config = { pkgs, ... }: {
          environment.systemPackages = [ pkgs.hello ];
        };
      };
    };
    nixos.containers.zones = {
      foo = {};
    };
    networking = {
      useNetworkd = true;
      useDHCP = false;
      interfaces.eth0.useDHCP = true;
      interfaces.eth1.useDHCP = true;
    };
    programs.mtr.enable = true;
    environment.systemPackages = [ pkgs.tcpdump pkgs.tmux ];
    time.timeZone = "Europe/Berlin";
    networking.firewall.allowedUDPPorts = [ 67 68 546 547 ];
  };

  testScript = ''
    start_all()

    server.shutdown()
  '';
})
