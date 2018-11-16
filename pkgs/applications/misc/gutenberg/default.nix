{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  name = "gutenberg-${version}";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "gutenberg";
    rev = "v${version}";
    sha256 = "0kzxz26khk5rwb9mz0wi9r8y7r93w4n2dbq6v2qr07cy5h14pa6w";
  };

  cargoSha256 = "0n4ji06chybmcvg5yz6cnhzqh162zhh5xpbz374a796dwp1132m8";

  nativeBuildInputs = [ cmake pkgconfig openssl ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices cf-private ];

  postInstall = ''
    install -D -m 444 completions/gutenberg.bash \
      -t $out/share/bash-completion/completions
    install -D -m 444 completions/_gutenberg \
      -t $out/share/zsh/site-functions
    install -D -m 444 completions/gutenberg.fish \
      -t $out/share/fish/vendor_completions.d
  '';

  meta = with stdenv.lib; {
    description = "An opinionated static site generator with everything built-in";
    homepage = https://www.getgutenberg.io;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
