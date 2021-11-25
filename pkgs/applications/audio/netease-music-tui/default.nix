{ fetchFromGitHub, rustPlatform, lib, alsa-lib, pkg-config, openssl }:

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
  buildInputs = [ alsa-lib openssl ];

  cargoSha256 = "1pca0sz4rz8qls6k2vhf70ixhnvgk81c4hbx81q3pv106g5k205f";

  meta = with lib; {
    homepage = "https://github.com/betta-cyber/netease-music-tui";
    description = "netease cloud music terminal client by rust";
    maintainers = with maintainers; [ vonfry ];
    license = licenses.mit;
  };
}
