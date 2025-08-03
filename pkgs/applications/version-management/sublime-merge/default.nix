{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2110";
    aarch64sha256 = "lG95VgRsicSRjve7ESTamU9dp/xBjR6yyLL+1wh6BXg=";
    x64sha256 = "v5CFqS+bB0Oe0fZ+vP0zxrJ2SUctNXKqODmB8M9XMIY=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2109";
    dev = true;
    aarch64sha256 = "kkXt+CdmU2C6VJHKvp5M4VzzxhhgSqeFVyORWMQnVTc=";
    x64sha256 = "O1pY4M98mfBY8VaOYYOTRCNTNeUQYmHlB0h1A0GTpe8=";
  } { };
}
