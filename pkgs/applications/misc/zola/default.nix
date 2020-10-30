{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:0fb227kgani32ljnw73a0h5zn5361z5lraf79y34a0chcby2qv35";
  };

  cargoSha256 = "sha256:0ilfr32zcajag05qcpwi5ixz250s427i4xrjf4wrk7qy32bblnr5";

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
    maintainers = with maintainers; [ dywedir _0x4A6F ];
  };
}
