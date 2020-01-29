{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-backup";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jsdw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h31j8clvk4gkw4mgva9p0ypf26zhf7f0y564fdmzyw6rsz9wzcj";
  };

  cargoSha256 = "1vfyhfdy5ks9zs9sy61ck9459w86hn9v6jqcar7rib82bclzr1mx";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jsdw/git-backup";
    description = "A tool to help you backup your git repositories from services like GitHub";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
