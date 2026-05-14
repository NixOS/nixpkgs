# To generate cert files:
# cp $(nix-build ../common/acme/server/generate-certs.nix --arg domain '(import ./snakeoil-certs.nix).domain' --no-out-link)/* .

let
  domain = "www.reddit.com";
in
{
  inherit domain;
  ca = {
    cert = ./ca.cert.pem;
    key = ./ca.key.pem;
  };
  ${domain} = {
    cert = ./${domain}.cert.pem;
    key = ./${domain}.key.pem;
  };
}
