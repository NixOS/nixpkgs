{ fetchFromGitHub, rustPlatform, lib, alsa-lib, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "netease-music-tui";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "betta-cyber";
    repo = "netease-music-tui";
    rev = "v${version}";
    sha256 = "sha256-ILJkejRKG2DRXgR6O2tAFbrbd8HtnLZJmITq7hF41DQ=";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib openssl ];

  cargoSha256 = "sha256-/JQDUtSSkuO9nrYVSkQOaZjps1BUuH8Bc1SMyDSSJS4=";

  meta = with lib; {
    homepage = "https://github.com/betta-cyber/netease-music-tui";
    description = "netease cloud music terminal client by rust";
    maintainers = with maintainers; [ vonfry ];
    license = licenses.mit;
  };
}
