{ fetchFromGitHub, rustPlatform, lib, alsa-lib, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "netease-music-tui";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "betta-cyber";
    repo = "netease-music-tui";
    rev = "v${version}";
    sha256 = "sha256-+zRXihWg65DtyX3yD04CsW8aXIvNph36PW2veeg36lg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib openssl ];

  cargoSha256 = "sha256-i+W/KwnqdaHcrdaWYUuCUeFlRKekVuEvFh/pxDolPNU=";

  meta = with lib; {
    homepage = "https://github.com/betta-cyber/netease-music-tui";
    description = "netease cloud music terminal client by rust";
    maintainers = with maintainers; [ vonfry ];
    license = licenses.mit;
  };
}
