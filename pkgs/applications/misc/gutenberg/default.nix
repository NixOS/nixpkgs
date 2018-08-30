{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  name = "gutenberg-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "gutenberg";
    rev = "v${version}";
    sha256 = "0is7156aim2ad8xg2f5068crc4gfvm89x8gxa25vc25p0yr1bpla";
  };

  cargoSha256 = "146vlr85n9d06am5ki76fh1vb5r8a4lzx5b7dmgi292kc3dsn41z";

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
