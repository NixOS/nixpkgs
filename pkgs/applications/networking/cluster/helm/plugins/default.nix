{ callPackage }:

let
  helm-schema-losisin = callPackage ./helm-schema-losisin.nix { };
in
{
  helm-cm-push = callPackage ./helm-cm-push.nix { };

  helm-diff = callPackage ./helm-diff.nix { };

  helm-dt = callPackage ./helm-dt.nix { };

  helm-git = callPackage ./helm-git.nix { };

  helm-mapkubeapis = callPackage ./helm-mapkubeapis.nix { };

  helm-s3 = callPackage ./helm-s3.nix { };

  helm-secrets = callPackage ./helm-secrets.nix { };

  inherit helm-schema-losisin;

  # Alias for backwards compatibility, points to the original package
  helm-schema = helm-schema-losisin;

  helm-unittest = callPackage ./helm-unittest.nix { };
}
