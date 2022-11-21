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

  manifest = pkgs.writeText "manifest" ''
    image: nixos/unstable
    tasks:
      - build: |
          cp /etc/os-release .
          echo test
    '';

  ticket = pkgs.writeText "ticket" ''
    From: submitter@example.com
    To: ~user/testtracker@todo.${domain}
    Subject: This project sucks

    foo bar bazticket
  '';

  token = "ANDNW2UAAAAAAAAEdXNlclc5Q2euPAZAYLZXiCx+8Vl0Tlq9y0IfE1G3HzvCa7Yp";

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
          nix.settings.trusted-users = [ "root" "build" ];
          system.stateVersion = config.system.nixos.release;
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

  nodes.machine = { config, pkgs, nodes, ... }: {
    # buildsrht needs space
    virtualisation.diskSize = 4 * 1024;
    virtualisation.memorySize = 4 * 1024;
    virtualisation.qemu.options = [ "-cpu" "max" "-smp" "2"];

    networking.domain = domain;
    networking.extraHosts = ''
      ${config.networking.primaryIPAddress} builds.${domain}
      ${config.networking.primaryIPAddress} git.${domain}
      ${config.networking.primaryIPAddress} meta.${domain}
      ${config.networking.primaryIPAddress} hg.${domain}
      ${config.networking.primaryIPAddress} paste.${domain}
      ${config.networking.primaryIPAddress} man.${domain}
      ${config.networking.primaryIPAddress} todo.${domain}
      ${config.networking.primaryIPAddress} logs.${domain}
    '';

    services.openssh.enable = true;
    services.postfix.enable = true;

    services.sourcehut = {
      enable = true;
      services = [
        "builds"
        "git"
        "hg"
        "meta"
        "paste"
        "man"
        "todo"
      ];
      nginx.enable = true;
      nginx.virtualHost = {
        forceSSL = true;
        sslCertificate = "${tls-cert}/cert.pem";
        sslCertificateKey = "${tls-cert}/key.pem";
      };
      postgresql.enable = true;
      postfix.enable = true;
      redis.enable = true;

      meta.enable = true;
      builds = {
        enable = true;
        enableWorker = true;
        inherit images;
      };
      git.enable = true;
      hg.enable = true;
      paste.enable = true;
      man.enable = true;
      todo.enable = true;

      settings."sr.ht" = {
        global-domain = config.networking.domain;
        service-key = pkgs.writeText "service-key" "8b327279b77e32a3620e2fc9aabce491cc46e7d821fd6713b2a2e650ce114d01";
        network-key = pkgs.writeText "network-key" "cEEmc30BRBGkgQZcHFksiG7hjc6_dK1XR2Oo5Jb9_nQ=";
      };
      settings."builds.sr.ht" = {
        oauth-client-secret = pkgs.writeText "buildsrht-oauth-client-secret" "2260e9c4d9b8dcedcef642860e0504bc";
        oauth-client-id = "299db9f9c2013170";
        shell = "/usr/bin/runner-shell";
      };
      settings."git.sr.ht" = {
        oauth-client-secret = pkgs.writeText "gitsrht-oauth-client-secret" "3597288dc2c716e567db5384f493b09d";
        oauth-client-id = "d07cb713d920702e";
      };
      settings."hg.sr.ht" = {
        oauth-client-secret = pkgs.writeText "hgsrht-oauth-client-secret" "567db5384e023b09d3597288dc2c716e";
        oauth-client-id = "920702ed1234713d";
      };
      settings."paste.sr.ht" = {
        oauth-client-secret = pkgs.writeText "hgsrht-oauth-client-secret" "567db5384f493b09d3597288dc2c716e";
        oauth-client-id = "920702ed07cb713d";
      };
      settings."man.sr.ht" = {
        oauth-client-secret = pkgs.writeText "hgsrht-oauth-client-secret" "1234b5384f493b09d3597288dc2c716e";
        oauth-client-id = "123402ed07cb713d";
      };
      settings."todo.sr.ht" = {
        oauth-client-secret = pkgs.writeText "hgsrht-oauth-client-secret" "abcdb5384f493b09d3597288dc2c716e";
        oauth-client-id = "abcd02ed07cb713d";
      };
      settings.webhooks.private-key = pkgs.writeText "webhook-key" "Ra3IjxgFiwG9jxgp4WALQIZw/BMYt30xWiOsqD0J7EA=";
      settings.mail = {
        smtp-host = "localhost";
        smtp-port = 25;
        smtp-encryption = "insecure";
        smtp-auth = "none";
        smtp-user = "unused"; # for some stupid reason this needs to be set even if auth = "none"
        smtp-from = "root+hut@${domain}";
        # WARNING: take care to keep pgp-privkey outside the Nix store in production,
        # or use LoadCredentialEncrypted=
        pgp-privkey = toString (pkgs.writeText "sourcehut.pgp-privkey" ''
          -----BEGIN PGP PRIVATE KEY BLOCK-----

          lFgEYqDRORYJKwYBBAHaRw8BAQdAehGoy36FUx2OesYm07be2rtLyvR5Pb/ltstd
          Gk7hYQoAAP9X4oPmxxrHN8LewBpWITdBomNqlHoiP7mI0nz/BOPJHxEktDZuaXhv
          cy90ZXN0cy9zb3VyY2VodXQgPHJvb3QraHV0QHNvdXJjZWh1dC5sb2NhbGRvbWFp
          bj6IlwQTFgoAPxYhBPqjgjnL8RHN4JnADNicgXaYm0jJBQJioNE5AhsDBQkDwmcA
          BgsJCAcDCgUVCgkICwUWAwIBAAIeBQIXgAAKCRDYnIF2mJtIySVCAP9e2nHsVHSi
          2B1YGZpVG7Xf36vxljmMkbroQy+0gBPwRwEAq+jaiQqlbGhQ7R/HMFcAxBIVsq8h
          Aw1rngsUd0o3dAicXQRioNE5EgorBgEEAZdVAQUBAQdAXZV2Sd5ZNBVTBbTGavMv
          D6ORrUh8z7TI/3CsxCE7+yADAQgHAAD/c1RU9xH+V/uI1fE7HIn/zL0LUPpsuce2
          cH++g4u3kBgTOYh+BBgWCgAmFiEE+qOCOcvxEc3gmcAM2JyBdpibSMkFAmKg0TkC
          GwwFCQPCZwAACgkQ2JyBdpibSMlKagD/cTre6p1m8QuJ7kwmCFRSz5tBzIuYMMgN
          xtT7dmS91csA/35fWsOykSiFRojQ7ccCSUTHL7ApF2EbL968tP/D2hIG
          =Hjoc
          -----END PGP PRIVATE KEY BLOCK-----
        '');
        pgp-pubkey = pkgs.writeText "sourcehut.pgp-pubkey" ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEYqDRORYJKwYBBAHaRw8BAQdAehGoy36FUx2OesYm07be2rtLyvR5Pb/ltstd
          Gk7hYQq0Nm5peG9zL3Rlc3RzL3NvdXJjZWh1dCA8cm9vdCtodXRAc291cmNlaHV0
          LmxvY2FsZG9tYWluPoiXBBMWCgA/FiEE+qOCOcvxEc3gmcAM2JyBdpibSMkFAmKg
          0TkCGwMFCQPCZwAGCwkIBwMKBRUKCQgLBRYDAgEAAh4FAheAAAoJENicgXaYm0jJ
          JUIA/17acexUdKLYHVgZmlUbtd/fq/GWOYyRuuhDL7SAE/BHAQCr6NqJCqVsaFDt
          H8cwVwDEEhWyryEDDWueCxR3Sjd0CLg4BGKg0TkSCisGAQQBl1UBBQEBB0BdlXZJ
          3lk0FVMFtMZq8y8Po5GtSHzPtMj/cKzEITv7IAMBCAeIfgQYFgoAJhYhBPqjgjnL
          8RHN4JnADNicgXaYm0jJBQJioNE5AhsMBQkDwmcAAAoJENicgXaYm0jJSmoA/3E6
          3uqdZvELie5MJghUUs+bQcyLmDDIDcbU+3ZkvdXLAP9+X1rDspEohUaI0O3HAklE
          xy+wKRdhGy/evLT/w9oSBg==
          =pJD7
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        pgp-key-id = "0xFAA38239CBF111CDE099C00CD89C8176989B48C9";
      };
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

    environment.systemPackages = [
      pkgs.openssh
      pkgs.git
      pkgs.mercurial
      pkgs.hut

      (pkgs.writeScriptBin "register-user"
      ''#!${pkgs.runtimeShell}
       set -e

       # register user with username 'user' and password 'password'
       echo password | metasrht-manageuser -ps -t admin -e test@example.com user

       tokenhash=$(echo -n ${token} | sha512sum | ${pkgs.gawk}/bin/gawk '{print $1}')

       # add a personal access token for this user
       ${pkgs.postgresql}/bin/psql '${config.services.sourcehut.settings."meta.sr.ht".connection-string}' -c \
       "insert into oauthtoken (token_hash, token_partial, created, updated, expires, scopes, user_id) values ('$tokenhash', 'nein', '2022-11-19 23:06:00.903505', '2022-11-19 23:06:00.903505', '2050-11-19 23:06:00.903505', '*', 1)"

       # use the same token for the new api
       ${pkgs.postgresql}/bin/psql '${config.services.sourcehut.settings."meta.sr.ht".connection-string}' -c \
       "insert into oauth2_grant (token_hash, issued, expires, user_id) values ('$tokenhash', '2022-11-19 23:06:00.903505', '2050-11-19 23:06:00.903505', 1)"

       # setup api client config
       mkdir -p ~/.config/hut;
       cat > ~/.config/hut/config <<EOF
       instance "${domain}" {
           access-token "${token}"
       }
       EOF
       '')
    ];
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    # Testing metasrht
    machine.wait_for_unit("metasrht-api.service")
    machine.wait_for_unit("metasrht.service")
    machine.wait_for_unit("metasrht-webhooks.service")
    machine.wait_for_open_port(5000)
    machine.succeed("curl -sL http://localhost:5000 | grep meta.${domain}")
    machine.succeed("curl -sL http://meta.${domain} | grep meta.${domain}")

    machine.succeed("register-user")

    # Testing gitsrht
    machine.wait_for_unit("gitsrht-api.service")
    machine.wait_for_unit("gitsrht.service")
    machine.wait_for_unit("gitsrht-webhooks.service")
    machine.succeed("curl -sL http://git.${domain} | grep git.${domain}")
    machine.wait_for_unit("sshd")
    machine.succeed("mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -N \"\"")
    machine.succeed("hut meta ssh-key create ~/.ssh/id_rsa.pub")
    machine.succeed("hut git create test")
    machine.succeed("git init")
    machine.succeed("git config core.sshCommand 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -F /dev/null'")
    machine.succeed("echo hello > file && git add file")
    machine.succeed("git commit -m 'initial import'")
    machine.succeed("git remote add origin 'gitsrht@git.${domain}:~user/test'")
    machine.succeed("git push origin master")
    machine.succeed("git clone 'https://git.${domain}/~user/test'")

    # testing hgsrht
    machine.wait_for_unit("hgsrht-api.service")
    machine.wait_for_unit("hgsrht.service")
    machine.wait_for_unit("hgsrht-webhooks.service")
    machine.succeed("curl -sL http://hg.${domain} | grep hg.${domain}")
    machine.succeed("hut hg create blub")
    machine.succeed("echo '[ui]' > ~/.hgrc")
    machine.succeed("echo ssh = ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -F /dev/null >> ~/.hgrc")
    machine.succeed("echo username = test user >> ~/.hgrc")
    machine.succeed("hg clone 'ssh://hgsrht@hg.${domain}/~user/blub'")
    machine.succeed("cd blub && echo hello > file && hg add file && hg commit -m blub && hg push")
    # FIXME
    # machine.succeed("hg clone 'https://hg.${domain}/~user/blub'")

    # testing pastesrht
    machine.wait_for_unit("pastesrht-api.service")
    machine.wait_for_unit("pastesrht.service")
    machine.succeed("curl -sL http://paste.${domain} | grep paste.${domain}")
    machine.succeed("echo PasteTestContent > pastefile")
    machine.succeed("curl -f $(hut paste create pastefile) | grep PasteTestContent")

    # testing mansrht
    machine.wait_for_unit("mansrht-api.service")
    machine.wait_for_unit("mansrht.service")
    machine.succeed("curl -L http://man.${domain} | grep man.${domain}")
    # no hut(1) support for api

    # testing todosrht
    machine.wait_for_unit("todosrht-api.service")
    machine.wait_for_unit("todosrht.service")
    machine.succeed("curl -L http://todo.${domain} | grep todo.${domain}")
    machine.succeed("echo description | hut todo create testtracker --stdin")
    machine.succeed("hut todo -t testtracker list")
    machine.succeed("sendmail -t < ${ticket}")
    machine.sleep(5)
    machine.succeed("hut todo -t testtracker ticket list | grep sucks")

    # Testing buildsrht
    machine.wait_for_unit("buildsrht.service")
    machine.wait_for_open_port(5002)
    machine.succeed("curl -sL http://localhost:5002 | grep builds.${domain}")
    machine.wait_for_unit("buildsrht-worker.service")
    machine.succeed("hut builds submit ${manifest}");
    machine.sleep(30);
    machine.succeed("hut builds show 1 | grep SUCCESS");

  '';
})
