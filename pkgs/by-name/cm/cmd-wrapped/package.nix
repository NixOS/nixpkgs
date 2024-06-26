{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cmd-wrapped";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "YiNNx";
    repo = "cmd-wrapped";
    rev = version;
    hash = "sha256-YWX4T3EiBIbEG/NGShuHRyxfdVGrqQH6J42EDkRblNQ=";
  };

  cargoHash = "sha256-CM2IpWs1vGiXHvQNgHyD6cUgMYSkp5+23j+YyF9G9IE=";

  meta = with lib; {
    description = "Find out what the past year looks like in commandline";
    homepage = "https://github.com/YiNNx/cmd-wrapped";
    license = licenses.mit;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "cmd-wrapped";
  };
}
