import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  domain = "sourcehut.localdomain";

  # Note that wildcard certificates just under the TLD (eg. *.com)
  # would be rejected by clients like curl.
  tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 36500 \
      -subj '/CN=${domain}' -extensions v3_req \
      -addext 'subjectAltName = DNS:*.${domain}'
    install -D -t $out key.pem cert.pem
  '';

  images = {
    nixos.unstable.x86_64 =
      let
        systemConfig = { pkgs, ... }: {
          # passwordless ssh server
          services.openssh = {
            enable = true;
            permitRootLogin = "yes";
            extraConfig = "PermitEmptyPasswords yes";
          };

          users = {
            mutableUsers = false;
            # build user
            extraUsers."build" = {
              isNormalUser = true;
              uid = 1000;
              extraGroups = [ "wheel" ];
              password = "";
            };
            users.root.password = "";
          };

          security.sudo.wheelNeedsPassword = false;
          nix.trustedUsers = [ "root" "build" ];
          documentation.nixos.enable = false;

          # builds.sr.ht-image-specific network settings
          networking = {
            hostName = "build";
            dhcpcd.enable = false;
            defaultGateway.address = "10.0.2.2";
            usePredictableInterfaceNames = false;
            interfaces."eth0".ipv4.addresses = [{
              address = "10.0.2.15";
              prefixLength = 25;
            }];
            enableIPv6 = false;
            nameservers = [
              # OpenNIC anycast
              "185.121.177.177"
              "169.239.202.202"
              # Google
              "8.8.8.8"
            ];
            firewall.allowedTCPPorts = [ 22 ];
          };

          environment.systemPackages = [
            pkgs.gitMinimal
            #pkgs.mercurial
            pkgs.curl
            pkgs.gnupg
          ];
        };
        qemuConfig = { pkgs, ... }: {
          imports = [ systemConfig ];
          fileSystems."/".device = "/dev/disk/by-label/nixos";
          boot.initrd.availableKernelModules = [
            "ahci"
            "ehci_pci"
            "sd_mod"
            "usb_storage"
            "usbhid"
            "virtio_balloon"
            "virtio_blk"
            "virtio_pci"
            "virtio_ring"
            "xhci_pci"
          ];
          boot.loader = {
            grub = {
              version = 2;
              device = "/dev/vda";
            };
            timeout = 0;
          };
        };
        config = (import (pkgs.path + "/nixos/lib/eval-config.nix") {
          inherit pkgs; modules = [ qemuConfig ];
          system = "x86_64-linux";
        }).config;
      in
      import (pkgs.path + "/nixos/lib/make-disk-image.nix") {
        inherit pkgs lib config;
        diskSize = 16000;
        format = "qcow2-compressed";
        contents = [
          { source = pkgs.writeText "gitconfig" ''
              [user]
                name = builds.sr.ht
                email = build@sr.ht
            '';
            target = "/home/build/.gitconfig";
            user = "build";
            group = "users";
            mode = "644";
          }
        ];
      };
  };

in
{
  name = "sourcehut";

  meta.maintainers = [ pkgs.lib.maintainers.tomberek ];

  machine = { config, pkgs, nodes, ... }: {
    # buildsrht needs space
    virtualisation.diskSize = 4 * 1024;
    virtualisation.memorySize = 2 * 1024;
    networking.domain = domain;
    networking.extraHosts = ''
      ${config.networking.primaryIPAddress} builds.${domain}
      ${config.networking.primaryIPAddress} git.${domain}
      ${config.networking.primaryIPAddress} meta.${domain}
    '';

    services.sourcehut = {
      enable = true;
      services = [
        "builds"
        "git"
        "meta"
      ];
      nginx.enable = true;
      nginx.virtualHost = {
        forceSSL = true;
        sslCertificate = "${tls-cert}/cert.pem";
        sslCertificateKey = "${tls-cert}/key.pem";
      };
      postgresql.enable = true;
      redis.enable = true;

      meta.enable = true;
      builds = {
        enable = true;
        # FIXME: see why it does not seem to activate fully.
        #enableWorker = true;
        inherit images;
      };
      git.enable = true;

      settings."sr.ht" = {
        global-domain = config.networking.domain;
        service-key = pkgs.writeText "service-key" "8b327279b77e32a3620e2fc9aabce491cc46e7d821fd6713b2a2e650ce114d01";
        network-key = pkgs.writeText "network-key" "cEEmc30BRBGkgQZcHFksiG7hjc6_dK1XR2Oo5Jb9_nQ=";
      };
      settings."builds.sr.ht" = {
        oauth-client-secret = pkgs.writeText "buildsrht-oauth-client-secret" "2260e9c4d9b8dcedcef642860e0504bc";
        oauth-client-id = "299db9f9c2013170";
      };
      settings."git.sr.ht" = {
        oauth-client-secret = pkgs.writeText "gitsrht-oauth-client-secret" "3597288dc2c716e567db5384f493b09d";
        oauth-client-id = "d07cb713d920702e";
      };
      settings.webhooks.private-key = pkgs.writeText "webhook-key" "Ra3IjxgFiwG9jxgp4WALQIZw/BMYt30xWiOsqD0J7EA=";
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
    security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
    };

    services.postgresql = {
      enable = true;
      enableTCPIP = false;
      settings.unix_socket_permissions = "0770";
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    # Testing metasrht
    machine.wait_for_unit("metasrht-api.service")
    machine.wait_for_unit("metasrht.service")
    machine.wait_for_open_port(5000)
    machine.succeed("curl -sL http://localhost:5000 | grep meta.${domain}")
    machine.succeed("curl -sL http://meta.${domain} | grep meta.${domain}")

    # Testing buildsrht
    machine.wait_for_unit("buildsrht.service")
    machine.wait_for_open_port(5002)
    machine.succeed("curl -sL http://localhost:5002 | grep builds.${domain}")
    #machine.wait_for_unit("buildsrht-worker.service")

    # Testing gitsrht
    machine.wait_for_unit("gitsrht.service")
    machine.succeed("curl -sL http://git.${domain} | grep git.${domain}")
  '';
})
