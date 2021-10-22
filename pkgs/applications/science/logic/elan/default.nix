{ stdenv, lib, runCommand, patchelf, makeWrapper, pkg-config, curl
, fetchpatch
, openssl, gmp, zlib, fetchFromGitHub, rustPlatform, libiconv }:

let
  libPath = lib.makeLibraryPath [ gmp ];
in

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "elan";
    rev = "v${version}";
    sha256 = "0xmml81krr0i18b14dymfdq43szpzws7qj8k404qab51lkqxyxsb";
  };

  cargoSha256 = "sha256-xjJ39hoSDn0VUH0YcL+mQBXbzFcIvZ38dPjBxV/yVNc=";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  OPENSSL_NO_VENDOR = 1;
  buildInputs = [ curl zlib openssl ]
    ++ lib.optional stdenv.isDarwin libiconv;

  cargoBuildFlags = [ "--features no-self-update" ];

  patches = lib.optionals stdenv.isLinux [
    # Run patchelf on the downloaded binaries.
    # This necessary because Lean 4 now dynamically links to GMP.
    (runCommand "0001-dynamically-patchelf-binaries.patch" {
        CC = stdenv.cc;
        patchelf = patchelf;
        libPath = "$ORIGIN/../lib:${libPath}";
      } ''
     export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
     substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
       --subst-var patchelf \
       --subst-var dynamicLinker \
       --subst-var libPath
    '')
    # fix build, will be included in 1.1.1
    (fetchpatch {
      url = "https://github.com/leanprover/elan/commit/8d1dec09d67b2ac1768b111d24f1a1cabdd563fa.patch";
      sha256 = "sha256-yMdnXqycu4VF9EKavZ85EuspvAqvzDSIm5894SB+3+A=";
    })
  ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker leanc leanmake lake; do
      ln -s elan $link
    done
    popd

    wrapProgram $out/bin/elan --prefix "LD_LIBRARY_PATH" : "${libPath}"

    # tries to create .elan
    export HOME=$(mktemp -d)
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/elan completions bash > "$out/share/bash-completion/completions/elan"
    $out/bin/elan completions fish > "$out/share/fish/vendor_completions.d/elan.fish"
    $out/bin/elan completions zsh >  "$out/share/zsh/site-functions/_elan"
  '';

  meta = with lib; {
    description = "Small tool to manage your installations of the Lean theorem prover";
    homepage = "https://github.com/leanprover/elan";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
  };
}
