{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4180";
    x64sha256 = "pl42AR4zWF3vx3wPSZkfIP7Oksune5nsbmciyJUv8D4=";
    aarch64sha256 = "zRg2jfhi+g6iLrMF1TGAYT+QQKSNI1W4Yv1bz9oEXHg=";
  } { };

  sublime4-dev = common {
    buildVersion = "4175";
    dev = true;
    x64sha256 = "xncyxAaFJLLMko/iF6fhnpkOEHzD3nzWWGQCRK9srq4=";
    aarch64sha256 = "oqz1HASwmv0B1T3ZQBdIOZD9wYcHbni8tovW7jGp3KM=";
  } { };
}
