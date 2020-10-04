{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "00fkcrr40v93z23h3q2wqlfx0120g59j6j9szk8nx9x85i40j3if";
  };

  cargoSha256 = "1wdypyy787dzdq5q64a9mjfygg0kli49yjzw7xh66sjd7263w9fs";

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
