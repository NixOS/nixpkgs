# Downloads the Agda Package Index from https://github.com/agda/package-index and parses it into nix derivations
{ pkgs }:
with pkgs.lib;
with builtins;
let
  package-index = fetchTarball {
    url = "https://github.com/agda/package-index/archive/1bae82e018550dd5fdf46d9d98277f396ee59c1d.tar.gz";
    sha256 = "08fcbh2ci442zs29bdg83s898svbr8bw0jr32kkp280943cb57h7";
  };
  makeAgdaPackage = name: { mkDerivation }: mkDerivation rec {
    inherit name;
    pname = name;

    src =
      let
        basePath = "${package-index}/src/${name}";
        revDir = head (attrNames (readDir "${package-index}/src/${name}/versions/")); # For now grab some ref at random
      in fetchGit {
      url = readFile "${basePath}/url";
      rev = readFile "${basePath}/versions/${revDir}/sha1";
    };
  };
  makeAgdaPackageAttr = name: {
    inherit name;
    value = makeAgdaPackage name;
  };
  thing = listToAttrs (map makeAgdaPackageAttr (attrNames (readDir "${package-index}/src")));
in
thing
