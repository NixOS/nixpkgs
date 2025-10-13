{ callPackage, fetchFromGitHub, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "3.3.0";

    src = fetchFromGitHub {
      owner = "msgpack";
      repo = "msgpack-c";
      rev = "cpp-${version}";
      sha256 = "02dxgzxlwn8g9ca2j4m0rjvdq1k2iciy6ickj615daz5w8pcjajd";
    };
  }
)
