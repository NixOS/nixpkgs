{
  callPackage,
  fetchFromGitHub,
}:

callPackage ./generic.nix rec {
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    tag = version;
    hash = "sha256-GnGyzNRpzuguc3yYbEFtYLvG+KiCtRAktiN+NvbOICE=";
  };
}
