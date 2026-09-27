{ callPackage }:

let
  helm-secrets = callPackage ./helm-secrets.nix { };
in
{
  helm-cm-push = callPackage ./helm-cm-push.nix { };

  helm-diff = callPackage ./helm-diff.nix { };

  helm-dt = callPackage ./helm-dt.nix { };

  helm-git = callPackage ./helm-git.nix { };

  helm-mapkubeapis = callPackage ./helm-mapkubeapis.nix { };

  helm-s3 = callPackage ./helm-s3.nix { };

  inherit helm-secrets;

  helm-secrets-getter = callPackage ./helm-secrets-getter.nix { };

  helm-secrets-post-renderer = callPackage ./helm-secrets-post-renderer.nix {
    inherit helm-secrets;
  };

  helm-schema = callPackage ./helm-schema.nix { };

  helm-unittest = callPackage ./helm-unittest.nix { };
}
