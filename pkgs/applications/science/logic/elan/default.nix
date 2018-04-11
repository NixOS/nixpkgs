{ stdenv, lib, pkgconfig, curl, openssl, zlib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "elan-${version}";
  version = "0.3.0";

  cargoSha256 = "01d3s47fjszxx8s5gr3haxq3kz3hswkrkr8x97wx8l4nfhm8ndd2";

  src = fetchFromGitHub {
    owner = "kha";
    repo = "elan";
    rev = "v${version}";
    sha256 = "116v9v1v5a6fr6h4dgxzwczpy4pbf96cnx6nss6a5y8vbhx9c1mj";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ curl zlib openssl ];

  cargoBuildFlags = [ "--features no-self-update" ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker; do
      ln -s elan $link
    done
    popd

    # tries to create .elan
    export HOME=$(mktemp -d)
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/elan completions bash > "$out/share/bash-completion/completions/elan"
    $out/bin/elan completions fish > "$out/share/fish/vendor_completions.d/elan.fish"
    $out/bin/elan completions zsh >  "$out/share/zsh/site-functions/_elan"
  '';

  meta = with stdenv.lib; {
    description = "Small tool to manage your installations of the Lean theorem prover";
    homepage = "https://github.com/Kha/elan";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
  };
}
