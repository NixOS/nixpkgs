{
  callPackage,
  javaPackages,
  lib,
  ...
}:

let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;
in
callPackage ./derivation.nix {
  inherit (versions.${latestVersion}) url version hash;
  jre = getJavaVersion versions.${latestVersion}.javaVersion;
}
