{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "peep";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ryochack";
    repo = "peep";
    rev = "v${version}";
    hash = "sha256-6Y7ZI0kIPE7uMMOkXgm75JMEec090xZPBJFJr9DaswA=";
  };

  cargoHash = "sha256-9VybBzW+saOjtQiyGu2pKHm94yCPw35Y56mhayCeW/c=";

  meta = with lib; {
    description = "CLI text viewer tool that works like less command on small pane within the terminal window";
    homepage = "https://github.com/ryochack/peep";
    changelog = "https://github.com/ryochack/peep/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "peep";
  };
}
