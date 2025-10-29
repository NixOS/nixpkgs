let
  domain = "acme.test";
in
{
  inherit domain;
  ca = {
    cert = ./ca.cert.pem;
    key = ./ca.key.pem;
  };
  "${domain}" = {
    cert = ./. + "/${domain}.cert.pem";
    key = ./. + "/${domain}.key.pem";
  };
}
