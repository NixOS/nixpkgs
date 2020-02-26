{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "112aqv21gy1fbly5v2x3ph32pr82d1mwh0q57yfaaqygz2madypb";
  };

  cargoSha256 = "0hqa60bx8pxhgad7x6r4zbwddrkcspnnp53bl94zbf3j47p10ggz";

  nativeBuildInputs = [ cmake pkg-config ];
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
    homepage = "https://www.getzola.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
