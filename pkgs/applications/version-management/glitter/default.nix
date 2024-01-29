{ lib, rustPlatform, fetchFromGitHub, git }:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sMAHVXpgAhZYUpl75JRtKhTqt/sQkSkoEzk7aGV1vcQ=";
  };

  cargoSha256 = "sha256-CaWpGNP7Jsv/3dks0LVbZXoD/9HqJmOzaD0ejT5xSqA=";

  nativeCheckInputs = [
    git
  ];

  # tests require it to be in a git repository
  preCheck = ''
    git init
  '';

  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  checkFlags = [ "--skip" "runs_correctly" ];

  meta = with lib; {
    description = "A git wrapper that allows you to compress multiple commands into one";
    homepage = "https://github.com/milo123459/glitter";
    changelog = "https://github.com/Milo123459/glitter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "glitter";
  };
}
