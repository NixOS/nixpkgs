{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SJp/iRF5os0f+WsHnLtcqmj0uD7fe8iODJ4F+gpWtJo=";
  };

  cargoSha256 = "sha256-CVqLwXgoHQjJ6NMyiZkxVaTO6qgzBQz8mH/6dsyhhYY=";

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
