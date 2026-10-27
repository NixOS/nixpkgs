{
  lib,
  javaPackages,
  stdenv,
  fetchurl,
  nixosTests,
  makeWrapper,
  udev,
}:
let
  versions = lib.importJSON ./versions.json;

  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "-" ];

  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;

  mkVersion = (
    version: value: {
      name = "vanilla-${escapeVersion version}";
      value = import ./derivation.nix {
        inherit
          lib
          stdenv
          fetchurl
          nixosTests
          makeWrapper
          udev
          ;
        inherit (value) version url sha1;
        jre_headless = getJavaVersion (
          if value.javaVersion == null then
            8
          else if value.javaVersion == 16 then
            17
          else
            value.javaVersion
        ); # versions <= 1.6 will default to 8
      };
    }
  );

  packages = lib.mapAttrs' mkVersion versions;
in
lib.recurseIntoAttrs (
  packages
  // {
    vanilla = (mkVersion latestVersion versions.${latestVersion}).value;
  }
)
