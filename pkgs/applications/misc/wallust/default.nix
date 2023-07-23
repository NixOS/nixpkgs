{ lib
, fetchgit
, rustPlatform
}:
let
  repoUrl = "https://codeberg.org/explosion-mental/wallust";
in
rustPlatform.buildRustPackage rec {
  pname = "wallust";
  version = "2.5.1";

  src = fetchgit {
    url = "${repoUrl}.git";
    rev = version;
    hash = "sha256-v72ddWKK2TMHKeBihYjMoJvKXiPe/yqJtdh8VQzjmVU=";
  };

  cargoSha256 = "sha256-jDs4KeVN3P+4/T1cW4KDxoY79jE3GXiwzxLrR2HybWw=";

  meta = with lib; {
    description = "A better pywal";
    homepage = repoUrl;
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    downloadPage = "${repoUrl}/releases/tag/${version}";
    platforms = platforms.unix;
    mainProgram = "wallust";
  };
}
