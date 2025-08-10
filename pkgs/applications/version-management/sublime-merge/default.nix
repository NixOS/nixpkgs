{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2102";
    aarch64sha256 = "E//XrWlfvMeRWYfBXVTSSUPlDFY/rzSynJ4aP1WyZ0Y=";
    x64sha256 = "Odb3ZvJCo4HTvJ7z31J/5wlyhSUpZRFBXP3f/Wkb7tU=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2109";
    dev = true;
    aarch64sha256 = "kkXt+CdmU2C6VJHKvp5M4VzzxhhgSqeFVyORWMQnVTc=";
    x64sha256 = "O1pY4M98mfBY8VaOYYOTRCNTNeUQYmHlB0h1A0GTpe8=";
  } { };
}
