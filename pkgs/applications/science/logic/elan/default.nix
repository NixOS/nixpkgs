{ stdenv, lib, pkgconfig, curl, openssl, zlib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "elan-${version}";
  version = "0.1.0";

  cargoSha256 = "04cxwklfgz4q28grva52ws3lslaiq67fwqf6pglbzdrfbgdjjwb6";

  src = fetchFromGitHub {
    owner = "kha";
    repo = "elan";
    rev = "v${version}";
    sha256 = "065l9a1g974n8i44mz37sx88fl65h5hml611m4p81cy6av2x85sm";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ curl zlib openssl ];

  cargoBuildFlags = [ "--features no-self-update" ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg; do
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
