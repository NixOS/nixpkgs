# end‐to‐end test for Akkoma
{
  lib,
  pkgs,
  confined ? false,
  ...
}:
let
  inherit ((pkgs.formats.elixirConf { }).lib) mkRaw;

  package = pkgs.akkoma;

  tlsCert =
    names:
    pkgs.runCommand "certificates-${lib.head names}"
      {
        nativeBuildInputs = with pkgs; [ openssl ];
      }
      ''
        mkdir -p $out
        openssl req -x509 \
          -subj '/CN=${lib.head names}/' -days 49710 \
          -addext 'subjectAltName = ${lib.concatStringsSep ", " (map (name: "DNS:${name}") names)}' \
          -keyout "$out/key.pem" -newkey ed25519 \
          -out "$out/cert.pem" -noenc
      '';

  tlsCertA = tlsCert [
    "akkoma-a.nixos.test"
    "media.akkoma-a.nixos.test"
  ];

  tlsCertB = tlsCert [
    "akkoma-b.nixos.test"
    "media.akkoma-b.nixos.test"
  ];

  testMedia = pkgs.runCommand "blank.png" { nativeBuildInputs = with pkgs; [ imagemagick ]; } ''
    magick -size 640x480 canvas:transparent "PNG8:$out"
  '';

  checkFe = pkgs.writeShellApplication {
    name = "checkFe";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      paths=( / /static/{config,styles}.json /pleroma/admin/ )

      for path in "''${paths[@]}"; do
        diff \
          <(curl -f -S -s -o /dev/null -w '%{response_code}' "https://$1$path") \
          <(echo -n 200)
      done
    '';
  };

  commonConfig =
    { nodes, ... }:
    {
      security.pki.certificateFiles = [
        "${tlsCertA}/cert.pem"
        "${tlsCertB}/cert.pem"
      ];

      networking.extraHosts = ''
        ${nodes.akkoma-a.networking.primaryIPAddress} akkoma-a.nixos.test media.akkoma-a.nixos.test
        ${nodes.akkoma-b.networking.primaryIPAddress} akkoma-b.nixos.test media.akkoma-b.nixos.test
        ${nodes.client-a.networking.primaryIPAddress} client-a.nixos.test
        ${nodes.client-b.networking.primaryIPAddress} client-b.nixos.test
      '';
    };

  clientConfig =
    { pkgs, ... }:
    {
      environment = {
        sessionVariables = {
          REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
        };
        systemPackages = with pkgs; [ toot ];
      };
    };

  serverConfig =
    { config, pkgs, ... }:
    {
      networking = {
        domain = "nixos.test";
        firewall.allowedTCPPorts = [ 443 ];
      };

      systemd.services.akkoma.confinement.enable = confined;

      services.akkoma = {
        enable = true;
        inherit package;
        config = {
          ":pleroma" = {
            ":instance" = {
              name = "NixOS test Akkoma server";
              description = "NixOS test Akkoma server";
              email = "akkoma@nixos.test";
              notify_email = "akkoma@nixos.test";
              registration_open = true;
            };

            ":media_proxy" = {
              enabled = false;
            };

            "Pleroma.Web.Endpoint" = {
              url.host = config.networking.fqdn;
            };

            "Pleroma.Upload" = {
              base_url = "https://media.${config.networking.fqdn}/media/";
            };

            # disable certificate verification until we figure out how to
            # supply our own certificates
            ":http".adapter.pools = mkRaw "%{default: [conn_opts: [transport_opts: [verify: :verify_none]]]}";
          };
        };

        nginx.addSSL = true;
      };

      services.nginx.enable = true;
      services.postgresql.enable = true;
    };
in
{
  name = "akkoma";
  nodes = {
    client-a =
      { ... }:
      {
        imports = [
          clientConfig
          commonConfig
        ];
      };

    client-b =
      { ... }:
      {
        imports = [
          clientConfig
          commonConfig
        ];
      };

    akkoma-a =
      { ... }:
      {
        imports = [
          commonConfig
          serverConfig
        ];

        services.akkoma.nginx = {
          sslCertificate = "${tlsCertA}/cert.pem";
          sslCertificateKey = "${tlsCertA}/key.pem";
        };
      };

    akkoma-b =
      { ... }:
      {
        imports = [
          commonConfig
          serverConfig
        ];

        services.akkoma.nginx = {
          sslCertificate = "${tlsCertB}/cert.pem";
          sslCertificateKey = "${tlsCertB}/key.pem";
        };
      };
  };

  testScript = ''
    import json
    import random
    import string
    from shlex import quote

    def randomString(len):
      return "".join(random.choice(string.ascii_letters + string.digits) for _ in range(len))

    def registerUser(user, password):
      return 'pleroma_ctl user new {0} {0}@nixos.test --password {1} -y'.format(
        quote(user), quote(password))

    def loginUser(instance, user, password):
      return 'toot login_cli -i {}.nixos.test -e {}@nixos.test -p {}'.format(
        quote(instance), quote(user), quote(password))

    userAName = randomString(11)
    userBName = randomString(11)
    userAPassword = randomString(22)
    userBPassword = randomString(22)

    testMessage = randomString(22)
    testMedia = '${testMedia}'

    start_all()
    akkoma_a.wait_for_unit('akkoma-initdb.service')
    akkoma_b.wait_for_unit('akkoma-initdb.service')

    # test repeated initialisation
    akkoma_a.systemctl('restart akkoma-initdb.service')

    akkoma_a.wait_for_unit('akkoma.service')
    akkoma_b.wait_for_unit('akkoma.service')
    akkoma_a.wait_for_file('/run/akkoma/socket');
    akkoma_b.wait_for_file('/run/akkoma/socket');

    akkoma_a.succeed(registerUser(userAName, userAPassword))
    akkoma_b.succeed(registerUser(userBName, userBPassword))

    akkoma_a.wait_for_unit('nginx.service')
    akkoma_b.wait_for_unit('nginx.service')

    client_a.succeed(loginUser('akkoma-a', userAName, userAPassword))
    client_b.succeed(loginUser('akkoma-b', userBName, userBPassword))

    client_b.succeed('toot follow {}@akkoma-a.nixos.test'.format(userAName))
    client_a.wait_until_succeeds('toot followers | grep -F -q {}'.format(quote(userBName)))

    client_a.succeed('toot post {} --media {} --description "nothing to see here"'.format(
      quote(testMessage), quote(testMedia)))

    # verify test message
    status = json.loads(client_b.wait_until_succeeds(
      'toot status --json "$(toot timeline -1 | grep -E -o \'^ID [^ ]+\' | cut -d \' \' -f 2)"'))
    assert status['content'] == testMessage

    # compare attachment to original
    client_b.succeed('cmp {} <(curl -f -S -s {})'.format(quote(testMedia),
      quote(status['media_attachments'][0]['url'])))

    client_a.succeed('${lib.getExe checkFe} akkoma-a.nixos.test')
    client_b.succeed('${lib.getExe checkFe} akkoma-b.nixos.test')
  '';
}
