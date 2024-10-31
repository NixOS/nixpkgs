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
    buildVersion = "2101";
    dev = true;
    aarch64sha256 = "/56SBJ9ehoBCLTWYo8hGpn6/uqKxsSfcSzcJDd3uUMc=";
    x64sha256 = "AIH0VtEetiHdip0PIx1U1mcFlFz1gk0VCRDq4C5/wNM=";
  } { };
}
