{ callPackage
}:

{
  idea-community = callPackage ./build.nix {
    buildVer = "233.11799.300";
    buildType = "idea";
    ideaHash = "sha256-Z0vNJC9KbnLPpvvQ1kLaUG3GhX16wRIuFOSvDugBDDY=";
    androidHash = "sha256-Z0vNJC9KbnLPpvvQ1kLaUG3GhX16wRIuFOSvDugBDDY=";
    jpsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJPS=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
  pycharm-community = callPackage ./build.nix {
    buildVer = "233.11799.298";
    buildType = "pycharm";
    ideaHash = "sha256-Z0vNJC9KbnLPpvvQ1kLaUG3GhX16wRIuFOSvDugBDDY=";
    androidHash = "sha256-Z0vNJC9KbnLPpvvQ1kLaUG3GhX16wRIuFOSvDugBDDY=";
    jpsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJPS=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
}
