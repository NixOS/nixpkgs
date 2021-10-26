{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5yv0RZfGLS/cxOxettHQHSPldcq+xa+TNj6dDIAmzOM=";
  };

  cargoSha256 = "sha256-xG7aic7NCcltz9YmQ4V40/h3OR8Vt5IgApp4yoDbPuc=";

  # tests require it to be in a git repository
  preCheck = ''
    git init
  '';

  meta = with lib; {
    description = "A git wrapper that allows you to compress multiple commands into one";
    homepage = "https://github.com/milo123459/glitter";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
