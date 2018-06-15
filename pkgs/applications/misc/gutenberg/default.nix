{ stdenv, fetchFromGitHub, rustPlatform, cmake, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  name = "gutenberg-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "gutenberg";
    rev = "v${version}";
    sha256 = "03zhbwxp4dbqydiydx0hpp3vpg769zzn5i95h2sl868mpfia8gyd";
  };

  cargoSha256 = "0441lbmxx16aar6fn651ihk3psrx0lk3qdbbyih05xjlkkbk1qxs";

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
    maintainers = [];
    platforms = platforms.all;
  };
}
