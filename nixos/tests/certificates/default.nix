{ runTest }:
let
  testCert = {
    subject = {
      CN = "client.test";
    };
    extensions = {
      subjectAltName = {
        DNS = [ "www.client.test" ];
      };
    };
    install = {
      certificate = {
        path = "/run/cert.pem";
      };
      privateKey = {
        path = "/run/key.pem";
      };
      authority = {
        path = "/run/ca.pem";
      };
    };
  };
  defaults =
    { pkgs, ... }:
    {
      security.certificates.specifications = {
        inherit testCert;
      };
      environment.systemPackages = with pkgs; [
        openssl
        jq
        jc
      ];
    };
  # TODO: Make a more comprehensive test, file permissions, key type, etc?
  testScript = with testCert; ''
    start_all()
    machine.wait_for_unit("certificate-testCert.service")

    # Check correct files were created
    machine.succeed("test -e ${install.authority.path}")
    machine.succeed("test -e ${install.certificate.path}")
    machine.succeed("test -e ${install.privateKey.path}")

    # Check certificate is valid
    machine.succeed("openssl verify -verbose -x509_strict -CAfile ${install.authority.path} ${install.certificate.path}")

    # Export Certificate to JSON
    machine.succeed("jc --x509-cert < ${install.certificate.path} > /tmp/cert.json")

    # Check Common Name
    machine.succeed(
      """
        jq -e '.[].tbs_certificate.subject.common_name == "${subject.CN}"' < /tmp/cert.json
      """
    )
  '';

in
# TODO: Make a better certificate testing framework for multiple authorities to hook into
{
  local = runTest {
    inherit testScript defaults;
    name = "certificates-local";
    nodes.machine =
      { ... }:
      {
        security.certificates = {
          authorities.local = {
            roots.testRoot = {
              CN = "Test Root CA";
            };
          };
          defaultAuthority = "local";
          specifications.testCert.authority.local.root = "testRoot";
        };
      };
  };
  vault = runTest {
    inherit testScript defaults;
    name = "certificate-vault";
    node.pkgsReadOnly = false;
    nodes.machine =
      { config, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        security.certificates = {
          authorities.vault = {
            server.enable = true;
          };
          defaultAuthority = "vault";
        };
      };
  };
}
