{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  cacert,
}:
rustPlatform.buildRustPackage rec {
  pname = "prr";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = "prr";
    rev = "v${version}";
    hash = "sha256-G8/T3Jyr0ZtY302AvYxhaC+8Ld03cVL5Cuflz62e0mw=";
  };

  cargoHash = "sha256-R3gycEs9k0VSNd0tD8Fzgbu2ibhGvXgw8H1mnSlQMug=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  checkInputs = [ cacert ];

  meta = with lib; {
    description = "Tool that brings mailing list style code reviews to Github PRs";
    homepage = "https://github.com/danobi/prr";
    license = licenses.gpl2Only;
    mainProgram = "prr";
    maintainers = with maintainers; [ evalexpr ];
  };
}
