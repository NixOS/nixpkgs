{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cmd-wrapped";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "YiNNx";
    repo = "cmd-wrapped";
    rev = version;
    hash = "sha256-9GyeJFU8wLl2kCnrwZ+j+PwCRS17NvzgSCpulhXHYqQ=";
  };

  cargoHash = "sha256-i6LgLvLMDF696Tpn4yVA1XNuaTrABLVg3SgclHBq6Go=";

  meta = with lib; {
    description = "Find out what the past year looks like in commandline";
    homepage = "https://github.com/YiNNx/cmd-wrapped";
    license = licenses.mit;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "cmd-wrapped";
  };
}
