let
  domain = "*.test.nix";
  domainSanitized = "_.test.nix";
in
{
  inherit domain;
  ca = {
    cert = ./ca.cert.pem;
    key = ./ca.key.pem;
  };
  "${domain}" = {
    cert = ./. + "/${domainSanitized}.cert.pem";
    key = ./. + "/${domainSanitized}.key.pem";
  };
}
