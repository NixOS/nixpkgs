{ lib
, rustPlatform
, fetchFromGitHub
, pkgconfig
, openssl
, libredirect
, writeText
}:

rustPlatform.buildRustPackage rec {
  pname = "nym";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    rev = "v${version}";
    sha256 = "0wzk9qzjyax73lfjbbag412vw1fgk2wmhhry5hdlvdbkim42m5bn";
  };

  # fix outdated Cargo.lock
  cargoPatches = [ (writeText "fix-nym-cargo-lock.patch" ''
    --- a/Cargo.lock
    +++ b/Cargo.lock
    @@ -1826 +1826 @@
    -version = "0.8.0"
    +version = "0.8.1"
  '') ];

  cargoSha256 = "0zr5nzmglmvn6xfqgvipbzy8nw5cl3nf7zjmghkqdwi6zj9p9272";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ];

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
    platforms = with platforms; intersectLists (linux ++ darwin) (concatLists [ x86 x86_64 aarch64 arm ]);
  };
}
