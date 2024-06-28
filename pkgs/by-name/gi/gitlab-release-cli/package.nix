{ lib
, fetchFromGitLab
, buildGoModule
}:

buildGoModule rec {
  pname = "gitlab-release-cli";
  version = "0.18.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "release-cli";
    rev = "v${version}";
    sha256 = "sha256-CCSice/uMf2OfFNEpwwhX6A0wrSsC1v9XWEhAAwQRso=";
  };

  vendorHash = "sha256-UwDMRsWbk8rEv2d5FssIzCLby68YZULoxd3/JGLsCQU=";

  meta = with lib; {
    description = "GitLab toolset to create, retrieve and update releases";
    homepage = "https://gitlab.com/gitlab-org/release-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "release-cli";
  };
}
