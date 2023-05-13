{ rustPlatform, lib, fetchFromGitHub, ncurses, openssl, pkg-config, Security, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "taizen";
  version = "unstable-2020-05-02";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
    rev = "5e88a55abaa2bf4356aa5bc783c2957e59c63216";
    sha256 = "sha256-cMykIh5EDGYZMJ5EPTU6G8YDXxfUzzfRfEICWmDUdrA=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-E2Wd8y47yd1thY/Bo1raP4tPd5YqdWWP4R/e0NWOc/A=";

  meta = with lib; {
    homepage = "https://github.com/nerdypepper/taizen";
    license = licenses.mit;
    description = "curses based mediawiki browser";
    maintainers = with maintainers; [ ];
  };
}
