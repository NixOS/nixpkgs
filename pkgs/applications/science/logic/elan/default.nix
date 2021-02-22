{ lib, pkg-config, curl, openssl, zlib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "kha";
    repo = "elan";
    rev = "v${version}";
    sha256 = "sha256-YkGfuqtvVfPcxJ8UqD5QidcNEy5brTWGEK4fR64Yz70=";
  };

  cargoSha256 = "sha256-2fYicpoEERwD4OjdpseKQOkDvZlb7NnOZcb6Tu+rQdA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl zlib openssl ];

  cargoBuildFlags = [ "--features no-self-update" ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker leanc leanmake; do
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
