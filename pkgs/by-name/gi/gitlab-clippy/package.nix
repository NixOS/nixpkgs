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
    repo = pname;
    rev = version;
    hash = "sha256-d7SmlAWIV4SngJhIvlud90ZUSF55FWIrzFpkfSXIy2Y=";
  };
  cargoHash = "sha256-ztPbI+ncMNMKnIxUksxgz8GHQpLZ7SVWdC4QJWh18Wk=";

  # TODO re-add theses tests once they get fixed in upstream
  checkFlags = [
    "--skip cli::converts_error_from_pipe"
    "--skip cli::converts_warnings_from_pipe"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/dlalic/gitlab-clippy";
    description = "Convert clippy warnings into GitLab Code Quality report";
    mainProgram = "gitlab-clippy";
    license = licenses.mit;
    maintainers = with maintainers; [ wucke13 ];
  };
}
