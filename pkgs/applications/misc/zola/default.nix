{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "119ikgall6bv1r6h1pqcmc6nxkxld2lch04gk860zzk54jragbrp";
  };

  cargoSha256 = "1jx5bgfmbv0wljps1yv6yir2pjlb0vwzzba4i2sv32awv9y0q3v6";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl oniguruma ]
    ++ stdenv.lib.optional stdenv.isDarwin CoreServices;

  RUSTONIG_SYSTEM_LIBONIG = true;

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
    homepage = "https://www.getzola.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
