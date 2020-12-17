{ lib, bundlerApp }:

bundlerApp {
  pname = "gitlab-triage";
  gemdir = ./.;
  exes = [ "gitlab-triage" ];

  meta = with lib; {
    description = "GitLab's issues and merge requests triage, automated!";
    homepage = "https://gitlab.com/gitlab-org/gitlab-triage";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
