{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "15.11.1";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "sha256-BPChY2t0ygH73XZYDWDb0EVPqrniMxzg3JWgcmsAesA=";
  };

  vendorHash = "sha256-s3HHoz9URACuVVhePQQFviTqlQU7vCLOjTJPBlus1Vo=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}
