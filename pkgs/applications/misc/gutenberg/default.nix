{ stdenv, fetchFromGitHub, rustPlatform, cmake, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  name = "gutenberg-${version}";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "gutenberg";
    rev = "v${version}";
    sha256 = "1v26q1m3bx7mdmmwgd6p601ncf13rr4rrx9s06fiy8vnd0ar1vlf";
  };

  cargoSha256 = "0cdy0wvibkpnmlqwxvn02a2k2vqy6zdqzflj2dh6g1cjbz1j8qh5";

  nativeBuildInputs = [ cmake ];
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
