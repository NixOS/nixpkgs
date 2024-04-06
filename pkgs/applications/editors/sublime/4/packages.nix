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
    buildVersion = "4173";
    dev = true;
    x64sha256 = "JEf974X+m0XaZ5x2g4o5XYkdo2A0cIZNjFLCrIgFzEA=";
    aarch64sha256 = "+aVV7o59ZFwSOyV0DDNUpaq3q21bXslE+Oz/i33X+4Y=";
  } { };
}
