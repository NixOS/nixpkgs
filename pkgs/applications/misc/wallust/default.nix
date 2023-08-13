{ lib
, fetchFromGitea
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wallust";
  version = "2.5.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = pname;
    rev = version;
    hash = "sha256-v72ddWKK2TMHKeBihYjMoJvKXiPe/yqJtdh8VQzjmVU=";
  };

  cargoSha256 = "sha256-jDs4KeVN3P+4/T1cW4KDxoY79jE3GXiwzxLrR2HybWw=";

  meta = with lib; {
    description = "A better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    platforms = platforms.unix;
    mainProgram = "wallust";
  };
}
