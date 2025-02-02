{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dum";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "egoist";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rkdQb4TI7lfWE4REJYsIJwMcmM/78jjgQrd0ZvKJxk8=";
  };

  cargoHash = "sha256-rcb2Z+wl9neAGyH1DFrjboSCkD9JIKGwjJqAvU9Fitw=";

  meta = with lib; {
    description = "Npm scripts runner written in Rust";
    mainProgram = "dum";
    homepage = "https://github.com/egoist/dum";
    changelog = "https://github.com/egoist/dum/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
