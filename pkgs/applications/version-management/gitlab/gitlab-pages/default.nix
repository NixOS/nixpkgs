{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "16.1.4";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "sha256-9hqPeyabnAzmgj8rtmSgPG4QCnnSKc9wpAyFFa3uZpY=";
  };

  vendorHash = "sha256-SN4r9hcTTQUr3miv2Cm7iBryyh7yG1xx9lCvq3vQwc0=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 das_j ] ++ teams.gitlab.members;
  };
}
