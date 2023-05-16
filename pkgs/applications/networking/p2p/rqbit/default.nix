{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "2.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7n+T+y60RjmZC7bE96Ljg0xVg4bSzV/LFgezTld4zfI=";
  };

  cargoHash = "sha256-hcuZ4hqGJT/O7vFefKPGZlkqhdsAl5LGAcSRQAEopnM=";
=======
    sha256 = "sha256-AzlYeHPCDri/FxAh5R5AES+OAfzhwqB8/ewRwDU1nnU=";
  };

  cargoSha256 = "sha256-CqEnQNbwiB6+zM8gWhplvFPblKp+mPMAtnHP8JZiKv4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "A bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
