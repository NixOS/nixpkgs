{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dImQLC7owPf2EB5COO5vjN3a6k7gJ88D2hMSUW2/wn4=";
  };

  cargoHash = "sha256-7JQcY3HCG3UQ0Mfz/+ZZ0axGEpQoH410FT72tjHW7EE=";

  nativeCheckInputs = [
    git
  ];

  # tests require it to be in a git repository
  preCheck = ''
    git init
  '';

  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  checkFlags = [
    "--skip"
    "runs_correctly"
  ];

  meta = with lib; {
    description = "A git wrapper that allows you to compress multiple commands into one";
    homepage = "https://github.com/milo123459/glitter";
    changelog = "https://github.com/Milo123459/glitter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "glitter";
  };
}
