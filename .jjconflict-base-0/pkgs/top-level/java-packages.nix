{ pkgs }:

with pkgs;

{
  inherit (pkgs) openjfx17 openjfx21 openjfx23;

  compiler =
    let
      mkOpenjdk =
        featureVersion: path-darwin:
        if stdenv.hostPlatform.isLinux then
          mkOpenjdkLinuxOnly featureVersion
        else
          let
            openjdk = callPackage path-darwin { };
          in
          openjdk // { headless = openjdk; };

      mkOpenjdkLinuxOnly =
        featureVersion:
        let
          openjdk = callPackage ../development/compilers/openjdk/generic.nix { inherit featureVersion; };
        in
        assert stdenv.hostPlatform.isLinux;
        openjdk
        // {
          headless = openjdk.override { headless = true; };
        };

    in
    rec {
      corretto11 = callPackage ../development/compilers/corretto/11.nix { };
      corretto17 = callPackage ../development/compilers/corretto/17.nix { };
      corretto21 = callPackage ../development/compilers/corretto/21.nix { };

      openjdk8 = mkOpenjdk "8" ../development/compilers/zulu/8.nix;
      openjdk11 = mkOpenjdk "11" ../development/compilers/zulu/11.nix;
      openjdk17 = mkOpenjdk "17" ../development/compilers/zulu/17.nix;
      openjdk21 = mkOpenjdk "21" ../development/compilers/zulu/21.nix;
      openjdk23 = mkOpenjdk "23" ../development/compilers/zulu/23.nix;

      # Legacy aliases
      openjdk8-bootstrap = temurin-bin.jdk-8;
      openjdk11-bootstrap = temurin-bin.jdk-11;
      openjdk17-bootstrap = temurin-bin.jdk-17;

      temurin-bin = recurseIntoAttrs (
        callPackage (
          if stdenv.hostPlatform.isLinux then
            ../development/compilers/temurin-bin/jdk-linux.nix
          else
            ../development/compilers/temurin-bin/jdk-darwin.nix
        ) { }
      );

      semeru-bin = recurseIntoAttrs (
        callPackage (
          if stdenv.hostPlatform.isLinux then
            ../development/compilers/semeru-bin/jdk-linux.nix
          else
            ../development/compilers/semeru-bin/jdk-darwin.nix
        ) { }
      );
    };
}
// lib.optionalAttrs config.allowAliases {
  jogl_2_4_0 = throw "'jogl_2_4_0' is renamed to/replaced by 'jogl'";
  mavenfod = throw "'mavenfod' is renamed to/replaced by 'maven.buildMavenPackage'";
}
