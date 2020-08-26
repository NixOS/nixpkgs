{ lib, pkgconfig, curl, openssl, zlib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "kha";
    repo = "elan";
    rev = "v${version}";
    sha256 = "0ycw1r364g5gwh8796dpv1israpg7zqwx8mcvnacv2lqj5iijmby";
  };

  cargoSha256 = "0hcaiy046d2gnkp6sfpnkkprb3nd94i9q8dgqxxpwrc1j157x6z9";

  nativeBuildInputs = [ pkgconfig ];

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
