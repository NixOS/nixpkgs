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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = "prr";
    rev = "v${version}";
    hash = "sha256-duoC3TMgW+h5OrRCbqYPppMtnQBfS9R7ZpHQySgPRv4=";
  };

  cargoHash = "sha256-W66kbTk0IAThl2H35EYuXr6UAyWfhmV0DxpnABhppSQ=";

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
