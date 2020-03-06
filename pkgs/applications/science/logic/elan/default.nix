{ lib, pkgconfig, curl, openssl, zlib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kha";
    repo = "elan";
    rev = "v${version}";
    sha256 = "1147f3lzr6lgvf580ppspn20bdwnf6l8idh1h5ana0p0lf5a0dn1";
  };

  cargoSha256 = "19bhfpbj1isr448kpjws8w6b08gl9pafjd4fry7kzh9mhkf0rf7i";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ curl zlib openssl ];

  cargoBuildFlags = [ "--features no-self-update" ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker leanc; do
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

  meta = with lib; {
    description = "Small tool to manage your installations of the Lean theorem prover";
    homepage = "https://github.com/Kha/elan";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
  };
}
