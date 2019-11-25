{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "13kbgxh7r6124d1fjdf0x599j1kpgixp1y9d299zb5vrd6rf5wy5";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "03rwf5l1l3ap03qi0xqcxsbyvpg3cqmr50j8ql6c5v55xl0ki9w8";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin CoreServices;

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
