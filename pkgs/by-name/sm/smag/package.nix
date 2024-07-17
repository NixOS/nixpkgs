{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "smag";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "aantn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PdrK4kblXju23suMe3nYFT1KEbyQu4fwP/XTb2kV1fs=";
  };

  cargoHash = "sha256-SX6tOodmB0usM0laOt8mjIINPYbzHI4gyUhsR21Oqrw=";

  meta = with lib; {
    description = "Easily create graphs from cli commands and view them in the terminal";
    longDescription = ''
      Easily create graphs from cli commands and view them in the terminal.
      Like the watch command but with a graph of the output.
    '';
    homepage = "https://github.com/aantn/smag";
    license = licenses.mit;
    changelog = "https://github.com/aantn/smag/releases/tag/v${version}";
    mainProgram = "smag";
    maintainers = with maintainers; [ zebreus ];
  };
}
