{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.6.3";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "sha256-AhC3c6CpV0tlD6d/hFWt7hGj2UsXsOCeujkRSDlpvCM=";
  };

  cargoSha256 = "sha256-Xo5iYwL4Db+GWMl5UXbPmj0Y0PJYR4Q0aUGnYCd+NB8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ]
    ++ (if stdenv.isDarwin then [ libiconv Security ] else [ openssl ]);

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3Plus ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
