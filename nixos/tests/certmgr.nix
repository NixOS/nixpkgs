{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib
}:

with lib;
with import ../lib/testing.nix { inherit system pkgs; };

let
  mkSpec = { host, service ? null, action }: {
    inherit service action;
    authority = {
      file = {
        group = "nobody";
        owner = "nobody";
        path = "/tmp/${host}-ca.pem";
      };
      remote = "https://127.0.0.1:8888";
      profile = "default";
      rootCA = "/tmp/certmgr-ca.pem";
      trustOnBootstrap = true;
      authKeyFile = "/var/lib/cfssl/default-key.secret";
    };
    certificate = {
      path = "/tmp/${host}-cert.pem";
      group = "nobody";
      owner = "nobody";
    };
    privateKey = {
      path = "/tmp/${host}-key.pem";
      owner = "nobody";
      group = "nobody";
      mode = "0600";
    };
    request = {
      CN = host;
      hosts = [ host "www.${host}" ];
      key = {
        algo = "rsa";
        size = 2048;
      };
      names = singleton {
        C = "US";
        L = "San Francisco";
        O = "Example, LLC";
        ST = "CA";
      };
    };
  };

  mkSpecImp = { host, service ? null, action }: toString (pkgs.writeText "test.json" (builtins.toJSON {
    inherit service action;
    authority = {
      file = {
        group = "nobody";
        owner = "nobody";
        path = "/tmp/${host}-ca.pem";
      };
      remote = "https://127.0.0.1:8888";
      profile = "default";
      root_ca = "/tmp/certmgr-ca.pem";
      auth_key_file = "/var/lib/cfssl/default-key.secret";
    };
    certificate = {
      path = "/tmp/${host}-cert.pem";
      group = "nobody";
      owner = "nobody";
    };
    private_key = {
      path = "/tmp/${host}-key.pem";
      owner = "nobody";
      group = "nobody";
      mode = "0600";
    };
    request = {
      CN = host;
      hosts = [ host "www.${host}" ];
      key = {
        algo = "rsa";
        size = 2048;
      };
      names = singleton {
        C = "US";
        L = "San Francisco";
        O = "Example, LLC";
        ST = "CA";
      };
    };
  }));

  mkCertmgrTest = { svcManager, specs, testScript }: makeTest {
    name = "certmgr-" + svcManager;
    nodes = {
      machine = { config, lib, pkgs, ... }: {
        networking.extraHosts = "127.0.0.1 imp.example.org decl.example.org";

        services.cfssl = {
          enable = true;
          logLevel = 0;
          initssl.enable = true;
          initca = {
            enable = true;
            csr = {
              hosts = [ "ca.example.com" ];
              key = {
                algo = "rsa";
                size = 4096;
              };
              names = singleton {
                C = "US";
                L = "San Francisco";
                O = "Internet Widgets, LLC";
                OU = "Certificate Authority";
                ST = "California";
              };
            };
          };
          configuration = {
            authKeys = {
              default.generate = true;
            };
            signing.default = {
              expiry = "8760h";
              usages = [ "signing" "key encipherment" "server auth" ];
              authKey = "default";
            };
          };
        };

        services.nginx = {
          enable = true;
          virtualHosts = lib.mkMerge (map (host: {
            ${host} = {
              sslCertificate = "/tmp/${host}-cert.pem";
              sslCertificateKey = "/tmp/${host}-key.pem";
              extraConfig = ''
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
              '';
              onlySSL = true;
              serverName = host;
              root = pkgs.writeTextDir "index.html" "It works!";
            };
          }) [ "imp.example.org" "decl.example.org" ]);
        };

        systemd.services.nginx.wantedBy = lib.mkForce [];

        services.certmgr = {
          enable = true;
          inherit svcManager;
          inherit specs;
        };
      };
    };
    inherit testScript;
  };

in {
  systemd = mkCertmgrTest {
    svcManager = "systemd";
    specs = {
      decl = mkSpec { host = "decl.example.org"; service = "nginx"; action ="restart"; };
      imp = mkSpecImp { host = "imp.example.org"; service = "nginx"; action = "restart"; };
    };
    testScript = ''
      $machine->waitForUnit('certmgr.service');
      $machine->succeed('ls /tmp/decl.example.org-ca.pem');
      $machine->succeed('ls /tmp/decl.example.org-key.pem');
      $machine->succeed('ls /tmp/decl.example.org-cert.pem');
      $machine->succeed('ls /tmp/imp.example.org-ca.pem');
      $machine->succeed('ls /tmp/imp.example.org-key.pem');
      $machine->succeed('ls /tmp/imp.example.org-cert.pem');

      $machine->waitForUnit('nginx.service');
      $machine->succeed('[ "1" -lt "$(journalctl -u nginx | grep "Starting Nginx" | wc -l)" ]');
      $machine->succeed('curl --cacert /tmp/imp.example.org-ca.pem https://imp.example.org');
      $machine->succeed('curl --cacert /tmp/decl.example.org-ca.pem https://decl.example.org');
    '';
  };

  command = mkCertmgrTest {
    svcManager = "command";
    specs = {
      test = mkSpec { host = "command.example.org"; action = "touch /tmp/command.executed"; };
    };
    testScript = ''
      $machine->waitForUnit('certmgr.service');
      $machine->waitUntilSucceeds('stat /tmp/command.executed');
    '';
  };
}
