{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "gitlab-triage";
  gemdir = ./.;
  exes = [ "gitlab-triage" ];

  passthru.updateScript = bundlerUpdateScript "gitlab-triage";

  meta = with lib; {
    description = "GitLab's issues and merge requests triage, automated";
    homepage = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "gitlab-triage";
  };
}
