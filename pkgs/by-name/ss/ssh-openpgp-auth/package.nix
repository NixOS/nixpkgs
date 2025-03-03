{ callPackage }:

callPackage ./generic.nix {
  pname = "ssh-openpgp-auth";
  version = "0.2.2";
  srcHash = "sha256-5ew6jT6Zr54QYaWFQIGYXd8sqC3yHHZjPfoaCossm8o=";
  cargoHash = "sha256-PHJiyq7zovn7EA7jDLJQxjxu2ErPHqBMwAlJpb5UVQY=";
  metaDescription = "Command-line tool that provides client-side functionality to transparently verify the identity of remote SSH hosts";
}
