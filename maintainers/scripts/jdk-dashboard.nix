let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;

  jdkPackages = {
    corretto = {
      hasDefault = false;
      versions = [
        "11"
        "17"
        "21"
      ];
    };
    #     jetbrains.jdk = {
    #       hasDefault = false;
    #       versions = [ "11" "17" "21"];
    #     };
    # graalvmPackages.graalvm-ce
    #     graalvm-ce = {
    #       hasDefault = true;
    #       versions = [];
    #     };
    # graalvmPackages.graalvm-oracle
    #     graalvm-oracle = {
    #       hasDefault = true;
    #       versions = [ "_17"];
    #     };
    openjdk = {
      hasDefault = true;
      versions = [
        "11"
        "17"
        "21"
        "24"
      ];
    };
    semeru-bin = {
      hasDefault = true;
      # -8 is unsupported on aarch64-darwin where I'm developing
      versions = [
        "-11"
        "-17"
        "-21"
      ];
    };
    semeru-jre-bin = {
      hasDefault = true;
      # -8 is unsupported on aarch64-darwin where I'm developing
      versions = [
        "-11"
        "-17"
        "-21"
      ];
    };
    temurin-bin = {
      hasDefault = true;
      versions = [
        "-23"
        "-24"
      ];
    };
    temurin-jre-bin = {
      hasDefault = true;
      # -8 is unsupported on aarch64-darwin where I'm developing
      versions = [
        "-11"
        "-17"
        "-21"
        "-23"
        "-24"
      ];
    };
    zulu = {
      hasDefault = true;
      versions = [
        "11"
        "17"
        "21"
        "24"
      ];
    };
  };

  getVersion =
    name:
    let
      pkg = builtins.getAttr name pkgs;
    in
    pkg.version or (pkg.meta.version or "unknown");

  flattenVersions =
    attrset:
    lib.flatten (
      lib.mapAttrsToList (name: value: lib.map (version: "${name}${version}") value.versions) attrset
    );

  flatPackages = flattenVersions jdkPackages;

  versionMap = builtins.listToAttrs (
    builtins.map (name: {
      inherit name;
      value = getVersion name;
    }) flatPackages
  );

in
versionMap
