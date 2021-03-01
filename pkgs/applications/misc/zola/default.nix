{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yTvFQWmNxoB+CNZLHGmzJq7mKuOUxUqV4g8PWlOlRbM=";
  };

  cargoSha256 = "sha256:19vijhcs1i02jhz68acil7psv3pcn0jzi1i4y2l05i4m3ayxivjf";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl oniguruma ]
    ++ lib.optional stdenv.isDarwin CoreServices;

  RUSTONIG_SYSTEM_LIBONIG = true;

  postInstall = ''
    install -D -m 444 completions/zola.bash \
      -t $out/share/bash-completion/completions
    install -D -m 444 completions/_zola \
      -t $out/share/zsh/site-functions
    install -D -m 444 completions/zola.fish \
      -t $out/share/fish/vendor_completions.d
  '';

  meta = with lib; {
    description = "A fast static site generator with everything built-in";
    homepage = "https://www.getzola.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir _0x4A6F ];
  };
}
