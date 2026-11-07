{ pkgs, ... }:
let
  cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=fluxer.local' -days 36500
    mkdir -p $out
    cp key.pem cert.pem $out
  '';
in
{
  name = "fluxer-single-node-nginx";

  meta.maintainers = with pkgs.lib.maintainers; [
    strangeglyph
  ];

  enableDebugHook = true;
  sshBackdoor.enable = true;

  containers = {
    server =
      { pkgs, ... }:
      {
        imports = [
          (import ./server.nix { inherit cert; })
        ];

        services.fluxer.aux.nginx = {
          enable = true;
          virtualHost = {
            enableACME = pkgs.lib.mkForce false;
            forceSSL = true;
            sslCertificate = "${cert}/cert.pem";
            sslCertificateKey = "${cert}/key.pem";
          };
        };
      };

    client =
      { ... }:
      {
        imports = [
          (import ./client.nix { inherit cert; })
        ];
      };
  };

  testScript = import ./script.nix {
    inherit pkgs;
    extraInit = ''
      server.wait_for_unit("nginx.service")
      server.wait_for_open_port(443)
    '';
  };
}
