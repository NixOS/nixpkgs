{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "07zg4ia983rgvgvmw4xbi347lr4rxlf1xv8rw72cflc74kyia67n";
  };

  cargoSha256 = "13lnl01h8k8xv2ls1kjskfnyjmmk8iyk2mvbk01p2wmhp5m876md";

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
