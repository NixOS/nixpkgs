{ callPackage }:

{

  helm-diff = callPackage ./helm-diff.nix { };

  helm-git = callPackage ./helm-git.nix { };

  helm-cm-push = callPackage ./helm-cm-push.nix { };

  helm-s3 = callPackage ./helm-s3.nix { };

  helm-secrets = callPackage ./helm-secrets.nix { };

<<<<<<< HEAD
  helm-unittest = callPackage ./helm-unittest.nix { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
