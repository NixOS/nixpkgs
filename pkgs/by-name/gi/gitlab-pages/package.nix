{
  buildGoModule,
  lib,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-pages";
<<<<<<< HEAD
  version = "18.6.2";
=======
  version = "18.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-orEp/fkLmk0wKC8ceHesqYfA6yIDuxvFKX09MzA5fnU=";
=======
    hash = "sha256-dZEwBTjfHG6tHf4eBOML06yJwLTYC9u1c/8i3KJINh4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-AL6V2LPzCGo/7IuY8msip35OScfocp3zO2ZzM8cZfnU=";
  subPackages = [ "." ];

  ldflags = [
    "-X"
    "main.VERSION=${version}"
  ];

  meta = {
    description = "Daemon used to serve static websites for GitLab users";
    mainProgram = "gitlab-pages";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.gitlab ];
  };
}
