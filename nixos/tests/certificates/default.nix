{ runTest }:
let
  testCert = {
    request = {
      CN = "client.test";
      hosts = [ "www.client.test" ];
    };
    certificate = {
      path = "/run/cert.pem";
    };
    private_key = {
      path = "/run/key.pem";
    };
    ca = {
      path = "/run/ca.pem";
    };
  };
  defaults = { pkgs, ... }: {
    security.certificates.specifications = { inherit testCert; };
    environment.systemPackages = with pkgs; [
      openssl
      jq
      jc
    ];
  };
  # TODO: Make a more comprehensive test, file permissions, key type, etc? 
  testScript =
    with testCert;
    ''
      start_all()
      machine.wait_for_unit("certificate@testCert.service")
        
      # Check correct files were created
      machine.succeed("test -e ${ca.path}")
      machine.succeed("test -e ${certificate.path}")
      machine.succeed("test -e ${private_key.path}")

      # Check certificate is valid
      machine.succeed("openssl verify -verbose -x509_strict -CAfile ${ca.path} ${certificate.path}")

      # Export Certificate to JSON
      machine.succeed("jc --x509-cert < ${certificate.path} > /tmp/cert.json")

      # Check Common Name
      machine.succeed(
        """
          jq -e '.[].tbs_certificate.subject.common_name == "${request.CN}"' < /tmp/cert.json
        """
      )
    '';

in
# TODO: Make a better certificate testing framework for multiple authorities to hook into
{
  local = runTest {
    inherit testScript defaults;
    name = "certificates-local";
    nodes.machine = { pkgs, ... }: {
      security.certificates = {
        authorities.local = {
          roots.testRoot = { CN = "Test Root CA"; };
        };
        defaultAuthority.local = {
          root = "testRoot";
        };
      };
    };
  };
  vault = runTest {
    inherit testScript defaults;
    name = "certificate-vault";
    node.pkgsReadOnly = false;
    nodes.machine = { pkgs, config, lib, ... }: {
      nixpkgs.config.allowUnfree = true;
      security.certificates = {
        authorities.vault = {
          server.enable = true;
        };
        defaultAuthority.vault = config.security.certificates.authorities.vault.settings;
      };
    };
  };
}
