{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "nym";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    rev = "v${version}";
    sha256 = "sha256-7x+B+6T0cnEOjXevA5n1k/SY1Q2tcu0bbZ9gIGoljw0=";
  };

  cargoSha256 = "0a7yja0ihjc66fqlshlaxpnpcpdy7h7gbv6120w2cr605qdnqvkx";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv ];

  patches = [ ./ignore-networking-tests.patch ];
  checkType = "debug";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A mixnet providing IP-level privacy";
    longDescription = ''
      Nym routes IP packets through other participating nodes to hide their source and destination.
      In contrast with Tor, it prevents timing attacks at the cost of latency.
    '';
    homepage = "https://nymtech.net";
    license = licenses.asl20;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
