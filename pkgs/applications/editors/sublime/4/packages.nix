{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4169";
    x64sha256 = "jk9wKC0QgfhiHDYUcnDhsmgJsBPOUmCkyvQeI54IJJ4=";
    aarch64sha256 = "/W/xGbE+8gGu1zNh6lERZrfG9Dh9QUGkYiqTzp216JI=";
  } { };

  sublime4-dev = common {
    buildVersion = "4175";
    dev = true;
    x64sha256 = "xncyxAaFJLLMko/iF6fhnpkOEHzD3nzWWGQCRK9srq4=";
    aarch64sha256 = "oqz1HASwmv0B1T3ZQBdIOZD9wYcHbni8tovW7jGp3KM=";
  } { };
}
