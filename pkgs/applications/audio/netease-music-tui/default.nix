{ fetchFromGitHub, rustPlatform, lib, alsaLib, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "netease-music-tui";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "betta-cyber";
    repo = "netease-music-tui";
    rev = "v${version}";
    sha256 = "09355a6d197ckayh9833y39dsarklgpgrq3raapiv25z59di30qq";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib openssl ];

  cargoSha256 = "1p6z7p4z5kmsf12yfhxf84zzvkfsx0f1wl6mq5h0bsasdcba6v7s";

  meta = with lib; {
    homepage = "https://github.com/betta-cyber/netease-music-tui";
    description = "netease cloud music terminal client by rust";
    maintainers = with maintainers; [ vonfry ];
    license = licenses.mit;
  };
}
