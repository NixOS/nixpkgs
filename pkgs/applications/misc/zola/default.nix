{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "02lr1n3gf0agj8x451ndyvv16lq7rccazp4nz9zy0pzwxwrlwhra";
  };

  cargoSha256 = "003dhh41fh337k3djibpj6hyd16xprbgws3lbp7x37p4lx7qlnfy";

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
