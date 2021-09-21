{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "glitter";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "milo123459";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hj1md4h4m1g7cx41sjihlr8xq0zhkikci4cp2gbldqcq5x8iws4";
  };

  cargoSha256 = "sha256-2QgL8iH0FNlUR/863YML3PLad8lRkYjfSmbl49LTfWw=";

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
