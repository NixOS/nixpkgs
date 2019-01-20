{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  name = "zola-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    sha256 = "0as8nrzw9zz10w4xxiibgz8ylghc879b2pwaxnw8sjbji2d9qv63";
  };

  cargoSha256 = "0a14hq8d3xjr6yfg5qn5r7npqivm816f1p53bbm826igvpc9hsxa";

  nativeBuildInputs = [ cmake pkgconfig openssl ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices cf-private ];

  postInstall = ''
    install -D -m 444 completions/zola.bash \
      -t $out/share/bash-completion/completions
    install -D -m 444 completions/_zola \
      -t $out/share/zsh/site-functions
    install -D -m 444 completions/zola.fish \
      -t $out/share/fish/vendor_completions.d
  '';

  meta = with stdenv.lib; {
    description = "A fast static site generator with everything built-in";
    homepage = https://www.getzola.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
