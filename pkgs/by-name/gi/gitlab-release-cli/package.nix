{
  lib,
  fetchFromGitLab,
  buildGoModule,
  stdenv,
}:

buildGoModule rec {
  pname = "gitlab-release-cli";
  version = "0.19.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "release-cli";
    rev = "v${version}";
    hash = "sha256-AEDao1tehg15SmluHlivG/I+Y9Gcxjj7KUEGAmOZ1aY=";
  };

  vendorHash = "sha256-UwDMRsWbk8rEv2d5FssIzCLby68YZULoxd3/JGLsCQU=";

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Skip failing test
    "-skip TestHTTPSCustomCA"
  ];

  meta = {
    description = "Toolset to create, retrieve and update releases on GitLab";
    homepage = "https://gitlab.com/gitlab-org/release-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilimnik ];
    mainProgram = "release-cli";
  };
}
