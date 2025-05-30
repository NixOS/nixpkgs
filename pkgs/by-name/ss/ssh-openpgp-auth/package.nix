{ callPackage }:

callPackage ./generic.nix {
  pname = "ssh-openpgp-auth";
  version = "0.2.3";
  srcHash = "sha256-YS8/q8faWSRNciR03wwiiGGgkvZqb5Euto22pde53C8=";
  cargoHash = "sha256-rBkKQAq1IAc4udS65RvprQe6knxyAFKxCWKGW5k5te4=";
  metaDescription = "Command-line tool that provides client-side functionality to transparently verify the identity of remote SSH hosts";
}
