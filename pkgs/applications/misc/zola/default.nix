{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "11y5gb6lx040ax4b16fr3whkj4vmv8hlkvb50h58gs77payglf6l";
  };

  cargoSha256 = "19hqkj27dbsy4pi0i8mjjlhi4351yifvc6zln6scc2nd60p251h6";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices cf-private ];

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
