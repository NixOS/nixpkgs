{ callPackage
}:

{
  idea-community = callPackage ./build.nix {
    buildVer = "232.9921.47";
    buildType = "idea";
    ideaHash = "sha256-sibp2Pa+NNHEeHMDRol45XOK0JzEhIZeI7TY04SkIx4=";
    androidHash = "sha256-bc/UlR0DJQiQ3mdscucHkvzkSQxD0KnDFIM9UIb7Inw=";
    jpsHash = "sha256-dBz64oATg45BMwd6etncQm84eHQSfSE9kDbuU9IVpmo=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
  pycharm-community = callPackage ./build.nix {
    buildVer = "232.10072.31";
    buildType = "pycharm";
    ideaHash = "sha256-NTQGz5HViQlJQaxcAnsliZS4NCKScVqx25FMILkBjpk=";
    androidHash = "sha256-bc/UlR0DJQiQ3mdscucHkvzkSQxD0KnDFIM9UIb7Inw=";
    jpsHash = "sha256-dBz64oATg45BMwd6etncQm84eHQSfSE9kDbuU9IVpmo=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
}
