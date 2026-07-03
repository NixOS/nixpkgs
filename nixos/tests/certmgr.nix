{ runTest, pkgs, ... }:

let
  authKey = pkgs.writeText "auth-key" "1234ABCD";
  cfsslConfig = pkgs.writeText "config.json" (
    builtins.toJSON {
      # also see `cfssl print-defaults config`
      auth_keys = {
        my_key = {
          type = "standard";
          key = "file:${authKey}";
        };
      };
      signing = {
        default = {
          expiry = "168h";
          auth_key = "my_key";
          usages = [
            "digital signature"
          ];
        };
      };
    }
  );
  mkSpec =
    {
      host,
      service ? null,
      action,
    }:
    {
      inherit action;
      authority = {
        file = {
          group = "nginx";
          owner = "nginx";
          path = "/var/ssl/${host}-ca.pem";
        };
        label = "www_ca";
        profile = "three-month";
        remote = "localhost:8888";
        auth_key_file = toString authKey;
      };
      certificate = {
        group = "nginx";
        owner = "nginx";
        path = "/var/ssl/${host}-cert.pem";
      };
      private_key = {
        group = "nginx";
        mode = "0600";
        owner = "nginx";
        path = "/var/ssl/${host}-key.pem";
      };
      request = {
        CN = host;
        hosts = [
          host
          "www.${host}"
        ];
        key = {
          algo = "rsa";
          size = 2048;
        };
        names = [
          {
            C = "US";
            L = "San Francisco";
            O = "Example, LLC";
            ST = "CA";
          }
        ];
      };
      inherit service;
    };

  mkCertmgrTest =
    {
      svcManager,
      specs,
      testScript,
    }:
    runTest {
      name = "certmgr-" + svcManager;
      nodes = {
        machine =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            networking.firewall.allowedTCPPorts = with config.services; [
              cfssl.port
              certmgr.metricsPort
            ];
            networking.extraHosts = "127.0.0.1 imp.example.org decl.example.org";

            services.cfssl = {
              enable = true;
              configFile = toString cfsslConfig;
            };
            systemd.services.cfssl.after = [
              "cfssl-init.service"
              "network.target"
            ];

            systemd.tmpfiles.rules = [ "d /var/ssl 777 root root" ];

            systemd.services.cfssl-init = {
              description = "Initialize the cfssl CA";
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                User = "cfssl";
                Type = "oneshot";
                WorkingDirectory = config.services.cfssl.dataDir;
                # matches systemd.services.cfssl to run setup transparently
                StateDirectory = baseNameOf config.services.cfssl.dataDir;
                StateDirectoryMode = 700;
              };
              script = ''
                ${pkgs.cfssl}/bin/cfssl genkey -initca ${
                  pkgs.writeText "ca.json" (
                    builtins.toJSON {
                      hosts = [ "ca.example.com" ];
                      key = {
                        algo = "rsa";
                        size = 4096;
                      };
                      names = [
                        {
                          C = "US";
                          L = "San Francisco";
                          O = "Internet Widgets, LLC";
                          OU = "Certificate Authority";
                          ST = "California";
                        }
                      ];
                    }
                  )
                } | ${pkgs.cfssl}/bin/cfssljson -bare ca
              '';
            };

            services.nginx = {
              enable = true;
              virtualHosts = lib.mkMerge (
                map
                  (host: {
                    ${host} = {
                      sslCertificate = "/var/ssl/${host}-cert.pem";
                      sslCertificateKey = "/var/ssl/${host}-key.pem";
                      extraConfig = ''
                        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
                      '';
                      onlySSL = true;
                      serverName = host;
                      root = pkgs.writeTextDir "index.html" "It works!";
                    };
                  })
                  [
                    "imp.example.org"
                    "decl.example.org"
                  ]
              );
            };

            systemd.services.nginx.wantedBy = lib.mkForce [ ];

            systemd.services.certmgr.after = [ "cfssl.service" ];
            services.certmgr = {
              enable = true;
              inherit svcManager;
              inherit specs;
            };

          };
      };
      inherit testScript;
    };
in
{
  systemd = mkCertmgrTest {
    svcManager = "systemd";
    specs = {
      decl = mkSpec {
        host = "decl.example.org";
        service = "nginx";
        action = "restart";
      };
      imp = toString (
        pkgs.writeText "test.json" (
          builtins.toJSON (mkSpec {
            host = "imp.example.org";
            service = "nginx";
            action = "restart";
          })
        )
      );
    };
    testScript = ''
      machine.wait_for_unit("cfssl.service")
      machine.wait_until_succeeds("ls /var/ssl/decl.example.org-ca.pem")
      machine.wait_until_succeeds("ls /var/ssl/decl.example.org-key.pem")
      machine.wait_until_succeeds("ls /var/ssl/decl.example.org-cert.pem")
      machine.wait_until_succeeds("ls /var/ssl/imp.example.org-ca.pem")
      machine.wait_until_succeeds("ls /var/ssl/imp.example.org-key.pem")
      machine.wait_until_succeeds("ls /var/ssl/imp.example.org-cert.pem")
      machine.wait_for_unit("nginx.service")
      assert 1 < int(machine.succeed('journalctl -u nginx | grep "Starting Nginx" | wc -l'))
      machine.succeed("curl --cacert /var/ssl/imp.example.org-ca.pem https://imp.example.org")
      machine.succeed(
          "curl --cacert /var/ssl/decl.example.org-ca.pem https://decl.example.org"
      )
    '';
  };

  command = mkCertmgrTest {
    svcManager = "command";
    specs = {
      test = mkSpec {
        host = "command.example.org";
        action = "touch /tmp/command.executed";
      };
    };
    testScript = ''
      machine.wait_for_unit("cfssl.service")
      machine.wait_until_succeeds("stat /tmp/command.executed")
    '';
  };

}
