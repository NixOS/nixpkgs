{ callPackage }:

callPackage ./generic.nix {
  pname = "ssh-openpgp-auth";
  version = "0.2.2";
  srcHash = "sha256-5ew6jT6Zr54QYaWFQIGYXd8sqC3yHHZjPfoaCossm8o=";
  cargoHash = "sha256-/k/XAp7PHIJaJWf4Oa1JC1mMSR5pyeM4SSPCcr77cAg=";
  metaDescription =
    "Command-line tool that provides client-side functionality to transparently verify the identity of remote SSH hosts";
}
