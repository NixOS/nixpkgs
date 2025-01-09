{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "morsel";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SamLee514";
    repo = "morsel";
    rev = "v${version}";
    hash = "sha256-bb+88GIyd92kHJAs25mJ9vmq0Ha2q0fdHnpTXhX2BFE=";
  };

  cargoHash = "sha256-XRl71n+rV6MTQMz957K5/25SX9HvYVW6qAuHTdfRLLs=";

  meta = with lib; {
    description = "Command line tool to translate morse code input to text in real time";
    mainProgram = "morsel";
    homepage = "https://github.com/SamLee514/morsel";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
