{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, ncurses
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "taizen";
  version = "unstable-2020-05-02";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
    rev = "5e88a55abaa2bf4356aa5bc783c2957e59c63216";
    sha256 = "sha256-cMykIh5EDGYZMJ5EPTU6G8YDXxfUzzfRfEICWmDUdrA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "curses based mediawiki browser";
    homepage = "https://github.com/nerdypepper/taizen";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
