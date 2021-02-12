{ fetchFromGitHub, rustPlatform, lib, alsaLib, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "netease-music-tui";
  version = "v0.1.2";

  src = fetchFromGitHub {
    owner = "betta-cyber";
    repo = "netease-music-tui";
    rev = version;
    sha256 = "0m5b3q493d32kxznm4apn56216l07b1c49km236i03mpfvdw7m1f";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib openssl ];

  cargoSha256 = "1h4pzwh4r0m4axkspm7n9n645wkkr27yw4bfmiyzc849jdxsq9yn";
  verifyCargoDeps = true;

  meta = with lib; {
    homepage = "https://github.com/betta-cyber/netease-music-tui";
    description = "netease cloud music terminal client by rust";
    maintainers = with maintainers; [ vonfry ];
    license = licenses.mit;
  };
}
