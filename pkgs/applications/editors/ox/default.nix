{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-4I6RjSCfNyeSQwGn6zX9AhePkqr+uOuhXdV0tat1LqI=";
  };

  cargoHash = "sha256-VFrN58SRTRGH+RSc59RIdsysR3umnrU2KM5XVCp9u1Q=";

  meta = with lib; {
    description = "An independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
