{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "166kmlkzd1qyw9yq2jqs58z8b3d956jjhw9r15jzw98md949psr5";
  };

  cargoSha256 = "1brmlg6nqyls1v62z0fg0km150q9m7h71wy67lidcnw76icmqr24";

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
