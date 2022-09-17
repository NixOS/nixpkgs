{ callPackage }:

{

  helm-diff = callPackage ./helm-diff.nix { };

  helm-git = callPackage ./helm-git.nix { };

  helm-cm-push = callPackage ./helm-cm-push.nix { };

  helm-s3 = callPackage ./helm-s3.nix { };

  helm-secrets = callPackage ./helm-secrets.nix { };

}
