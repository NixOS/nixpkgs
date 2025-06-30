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
    buildVersion = "2108";
    dev = true;
    aarch64sha256 = "v81Xvp0tsXfbBkf8W53iC1YIcT5XJUYmXl6CWNdz6Hw=";
    x64sha256 = "nIwJIWMecBZgfaCFs0/iFHJG9k/3lAqsliCsfvnhpKY=";
  } { };
}
