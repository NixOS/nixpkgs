{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cmd-wrapped";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "YiNNx";
    repo = "cmd-wrapped";
    rev = "v${version}";
    hash = "sha256-tIvwJo33Jz9cPq6o4Ytc3VqkxEaxt0W9Fd8CNp+7vAE=";
  };

  cargoHash = "sha256-Pv+LTHMLJh4LxKmvF6aJLZlDf97ZHI8gzn7vP+quNhc=";

  meta = with lib; {
    description = "Find out what the past year looks like in commandline";
    homepage = "https://github.com/YiNNx/cmd-wrapped";
    license = licenses.mit;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "cmd-wrapped";
  };
}
