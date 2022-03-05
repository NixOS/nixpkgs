{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.5.14";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q1zPPT0gNI96n8PIk1qATRzxm5vmGmRMwZ9j7bb8knk=";
  };

  cargoSha256 = "sha256-JKM98cpZz2MTa+f2A7NRcKwGjbm4YRabMlV6DHXT64U=";

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
