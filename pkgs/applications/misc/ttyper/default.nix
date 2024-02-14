{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IvAx65b2rGsMdDUhRxTx8cyqnG7oxC+MseCFIJil1e0=";
  };

  cargoHash = "sha256-o3J2bEAV5NnWKFadJdSGTqUS8K2qpBKPQz6xAbfLtg4=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
