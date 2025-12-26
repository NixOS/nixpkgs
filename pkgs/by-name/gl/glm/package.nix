{
  callPackage,
  fetchFromGitHub,
}:

callPackage ./generic.nix rec {
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    rev = version;
    sha256 = "sha256-2xKv1nO+OdwA0r+I9OZ+OCL9dJFg/LJsQfIvIF76vc0=";
  };
}
