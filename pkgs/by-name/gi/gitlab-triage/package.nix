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

<<<<<<< HEAD
  meta = {
    description = "GitLab's issues and merge requests triage, automated";
    homepage = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "GitLab's issues and merge requests triage, automated";
    homepage = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "gitlab-triage";
  };
}
