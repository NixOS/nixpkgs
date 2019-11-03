import ./make-test.nix ({ pkgs, lib, ...}: with lib; {
  name = "cfssl";

  machine = { config, lib, pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ config.services.cfssl.port ];

    services.cfssl = {
      enable = true;
      dataDir = "/var/lib/cfssl";
      configuration = {
        signing = {
          profiles = {
            test = {
              usages = ["digital signature"];
              authKey = "default";
              expiry = "720h";
            };
          };
        };
        authKeys = {
          default.generate = true;
        };
      };
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
      initssl.enable = true;
    };
  };

  testScript = let
    cfsslrequest = req: with pkgs; writeScript "cfsslrequest" ''
      auth_key=$(cat /var/lib/cfssl/default-key.secret)
      auth_token=$(cat ${req} | ${openssl}/bin/openssl dgst -sha256 -mac HMAC -macopt hexkey:$auth_key -binary | base64 -w0)
      req_base64=$(cat ${req} | base64 -w0)
      newkey_req="{\"token\": \"$auth_token\", \"request\": \"$req_base64\"}"
      ${curl}/bin/curl -X POST -k -H "Content-Type: application/json" -d "$newkey_req" \
        https://localhost:8888/api/v1/cfssl/newkey | ${cfssl}/bin/cfssljson /tmp/certificate

      sign_request=$(echo "{\"certificate_request\": \"$(cat /tmp/certificate.csr)\", \"profile\": \"test\"}" | sed ':a;N;$!ba;s/\n/\\n/g')
      auth_token=$(echo "$sign_request" | ${openssl}/bin/openssl dgst -sha256 -mac HMAC -macopt hexkey:$auth_key -binary | base64 -w0)
      req_base64=$(echo "$sign_request" | base64 -w0)
      newkey_req="{\"token\": \"$auth_token\", \"request\": \"$req_base64\"}"
      ${curl}/bin/curl -X POST -k -H "Content-Type: application/json" -d "$newkey_req" \
        https://localhost:8888/api/v1/cfssl/authsign | ${cfssl}/bin/cfssljson /tmp/certificate
    '';
    req = pkgs.writeText "csr.json" (builtins.toJSON {
      CN = "www.example.com";
      hosts = [ "example.com" "www.example.com" ];
      key = {
        algo = "rsa";
        size = 2048;
      };
      names = singleton {
        C = "US";
        L = "San Francisco";
        O = "Example Company, LLC";
        OU = "Operations";
        ST = "California";
      };
    });
  in ''
    $machine->waitForUnit('cfssl.service');
    $machine->succeed('${cfsslrequest req}');
    $machine->succeed('${pkgs.openssl}/bin/openssl verify -CAfile /var/lib/cfssl/ca.pem /tmp/certificate.pem');
  '';
})
