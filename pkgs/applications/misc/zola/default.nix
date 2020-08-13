{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "137ak9gzcn3689fmcb90wa4szw43rh2m51mf26l77a5gksn5y6cn";
  };

  cargoSha256 = "0v40bcqh48dlhdc0kz7wm3q9r3i1m6j9s74bfiv237dqx5dymmsg";

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
