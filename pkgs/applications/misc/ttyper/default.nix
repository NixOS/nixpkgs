{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kMJcZ9U2pUXFza66fpK07IHbRc5ZQ49+bytgty94o/s=";
  };

  cargoHash = "sha256-pmPT8GREXKun5uyGx+b6IATp/cKziZTL7YcYwKEo/NU=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
