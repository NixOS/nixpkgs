{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IIF/bkTLwR8pCs/hJ625T3NsiKf/6Zf1cW2i4lsiK4U=";
  };

  cargoHash = "sha256-tDvqaNVuzv1BlS/oNI1D/WV1b5uHreT3Ak/6ruqKXQc=";

  meta = with lib; {
    description = "A cross-platform terminal UI used for modifying file data in hex or ASCII.";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
