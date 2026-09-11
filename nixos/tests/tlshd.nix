{ lib, pkgs, ... }:
let
  runWithOpenSSL =
    name: cmd:
    pkgs.runCommand name {
      buildInputs = [ pkgs.openssl ];
    } cmd;

  caKey = runWithOpenSSL "ca.key" "openssl ecparam -name prime256v1 -genkey -noout -out $out";
  caCert = runWithOpenSSL "ca.crt" ''
    openssl req -new -x509 -sha256 -key ${caKey} -out $out -subj "/CN=Test CA" -days 36500
  '';

  serverKey = runWithOpenSSL "server.key" "openssl ecparam -name prime256v1 -genkey -noout -out $out";
  serverCert = runWithOpenSSL "server.crt" ''
    openssl req -new -sha256 -key ${serverKey} -out server.csr -subj "/CN=server"
    openssl x509 -req -in server.csr -CA ${caCert} -CAkey ${caKey} \
      -CAcreateserial -out $out -days 36500 -sha256
  '';

  clientKey = runWithOpenSSL "client.key" "openssl ecparam -name prime256v1 -genkey -noout -out $out";
  clientCert = runWithOpenSSL "client.crt" ''
    openssl req -new -sha256 -key ${clientKey} -out client.csr -subj "/CN=client"
    openssl x509 -req -in client.csr -CA ${caCert} -CAkey ${caKey} \
      -CAcreateserial -out $out -days 36500 -sha256
  '';
in
{
  _class = "nixosTest";
  name = "tlshd";

  nodes = {
    server =
      { pkgs, ... }:
      {
        system.services.tlshd = {
          imports = [ pkgs.ktls-utils.services.default ];
          tlshd.settings = {
            "authenticate.server" = {
              "x509.certificate" = toString serverCert;
              "x509.private_key" = toString serverKey;
              "x509.truststore" = toString caCert;
            };
          };
        };

        services.nfs.server = {
          enable = true;
          exports = ''
            /export 192.168.1.0/24(rw,no_root_squash,no_subtree_check,xprtsec=mtls)
          '';
          createMountPoints = true;
        };

        networking.firewall.enable = false;
      };

    client =
      { pkgs, ... }:
      {
        system.services.tlshd = {
          imports = [ pkgs.ktls-utils.services.default ];
          tlshd.settings = {
            "authenticate.client" = {
              "x509.certificate" = toString clientCert;
              "x509.private_key" = toString clientKey;
              "x509.truststore" = toString caCert;
            };
          };
        };

        virtualisation.fileSystems."/mnt/nfs" = {
          device = "server:/export";
          fsType = "nfs";
          options = [ "xprtsec=mtls" ];
        };

        networking.firewall.enable = false;
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("nfs-server.service")
    server.wait_for_unit("tlshd.service")
    client.wait_for_unit("tlshd.service")
    client.wait_for_unit("mnt-nfs.mount")
    client.wait_until_succeeds("echo 'hello from client' > /mnt/nfs/test.txt")
    server.wait_until_succeeds("grep 'hello from client' /export/test.txt")
  '';

  meta.maintainers = with lib.maintainers; [ tomfitzhenry ];
}
