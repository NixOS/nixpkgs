{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LQlybr0l6MQiXak8+fwOi7/cuYi/LiFAW1Uulowkb5k=";
  };

  cargoSha256 = "sha256-RDf0Rby6n8aJyhFft8/t+tDLWeJi7GfIsrL8VjFdy9Y=";

  # tests require it to be in a git repository
  preCheck = ''
    git init
  '';

  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  checkFlags = [ "--skip" "runs_correctly" ];

  meta = with lib; {
    description = "A git wrapper that allows you to compress multiple commands into one";
    homepage = "https://github.com/milo123459/glitter";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
