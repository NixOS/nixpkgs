{
  callPackage,
  fetchFromGitHub,
}:

callPackage ./generic.nix rec {
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    tag = version;
    hash = "sha256-6WnVvFiTe1/OYj/oTGpCjZKNFurR9MxJ4zf0nDg0Alk=";
  };
}
