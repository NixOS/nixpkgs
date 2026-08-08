{ callPackage }:

{
  helm-cm-push = callPackage ./helm-cm-push.nix { };

  helm-diff = callPackage ./helm-diff.nix { };

  helm-dt = callPackage ./helm-dt.nix { };

  helm-git = callPackage ./helm-git.nix { };

  helm-mapkubeapis = callPackage ./helm-mapkubeapis.nix { };

  helm-s3 = callPackage ./helm-s3.nix { };

  helm-secrets = callPackage ./helm-secrets.nix { };

  helm-secrets-getter = callPackage ./helm-secrets-getter.nix { };

  helm-secrets-post-renderer = callPackage ./helm-secrets-post-renderer.nix { };

  helm-schema = callPackage ./helm-schema.nix { };

  helm-unittest = callPackage ./helm-unittest.nix { };
}
