{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GZO9xGc3KGdq2WdA10m/XV8cNAlQjUZFUVu1CzidJ5c=";
  };

  cargoHash = "sha256-BIyr/EaOjKDT5+4RFs3xz7zqAG1gblUqr2f+vl7B6Zo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.DisplayServices
  ];

  postInstall = ''
    installManPage doc/macchina.{1,7}
  '';

  meta = with lib; {
    description = "Fast, minimal and customizable system information fetcher";
    homepage = "https://github.com/Macchina-CLI/macchina";
    changelog = "https://github.com/Macchina-CLI/macchina/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _414owen figsoda ];
    mainProgram = "macchina";
  };
}
