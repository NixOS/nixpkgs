{ callPackage }:

{

  helm-diff = callPackage ./helm-diff.nix {};

  helm-s3 = callPackage ./helm-s3.nix {};

  helm-secrets = callPackage ./helm-secrets.nix {};

}
