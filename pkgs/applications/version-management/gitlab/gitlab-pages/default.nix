{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
<<<<<<< HEAD
  version = "16.3.3";
=======
  version = "15.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-TPXMXuxckALObfEcIguJbGToIGp8b2bpd974epaXpyk=";
  };

  vendorHash = "sha256-Pdb+bWsECe7chgvPKFGXxVAWb+AbGF6khVJSdDsHqKM=";
=======
    sha256 = "sha256-1qf/ZXOQBMT1aH0f6IyItTBUuhwVuE76sU8llRapZ0Q=";
  };

  vendorHash = "sha256-s3HHoz9URACuVVhePQQFviTqlQU7vCLOjTJPBlus1Vo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.gitlab.members;
=======
    maintainers = with maintainers; [ ajs124 das_j ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
