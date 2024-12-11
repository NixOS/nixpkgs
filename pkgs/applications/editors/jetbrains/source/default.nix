{ callPackage
}:

{
  idea-community = callPackage ./build.nix {
    version = "2024.1.3";
    buildNumber = "241.17890.1";
    buildType = "idea";
    ideaHash = "sha256-jWFnewxRkriSmV6CgGX1r//uaErMINfx3Z+JpkE34jk=";
    androidHash = "sha256-hX2YdRYNRg0guskNiYfxdl9osgZojRen82IhgA6G0Eo=";
    jpsHash = "sha256-Abr7L1FyqzRoUSDtsJs3cTEdkhORY5DzsQnOo5irVRI=";
    restarterHash = "sha256-XdjyuJUQMvhC0fl6sMj0sRWlqgUb3ZgBmKKXcD3egkk=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
  pycharm-community = callPackage ./build.nix {
    version = "2024.1.3";
    buildNumber = "241.17890.14";
    buildType = "pycharm";
    ideaHash = "sha256-tTB91/RHEWP/ZILPNFAbolVBLvgjLXTdD/uF/pdJ22Y=";
    androidHash = "sha256-hX2YdRYNRg0guskNiYfxdl9osgZojRen82IhgA6G0Eo=";
    jpsHash = "sha256-Abr7L1FyqzRoUSDtsJs3cTEdkhORY5DzsQnOo5irVRI=";
    restarterHash = "sha256-TbTIz9pc5wqL54TAMRoQ/9Ax/qsDp+r+h5jn2ub0hes=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
}
