{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-clippy";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "dlalic";
    repo = "gitlab-clippy";
    rev = version;
    hash = "sha256-d7SmlAWIV4SngJhIvlud90ZUSF55FWIrzFpkfSXIy2Y=";
  };

  cargoHash = "sha256-O3Pey0XwZITePTiVHrG5EVZpIp96sRWjUf1vzZ/JnCw=";

  # TODO re-add theses tests once they get fixed in upstream
  checkFlags = [
    "--skip cli::converts_error_from_pipe"
    "--skip cli::converts_warnings_from_pipe"
  ];

  meta = {
    homepage = "https://gitlab.com/dlalic/gitlab-clippy";
    description = "Convert clippy warnings into GitLab Code Quality report";
    mainProgram = "gitlab-clippy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wucke13 ];
  };
}
