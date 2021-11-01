{ stdenv, lib, runCommand, patchelf, makeWrapper, pkg-config, curl
, openssl, gmp, zlib, fetchFromGitHub, rustPlatform, libiconv }:

let
  libPath = lib.makeLibraryPath [ gmp ];
in

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "elan";
    rev = "v${version}";
    sha256 = "0gql015zb3y95v68kmv2dscz7fnh89x1shrqxxqk5a0jhd2z93n1";
  };

  cargoSha256 = "sha256-rL++3RstCSBMYFj9BeOo6gepfId/sje4ES3Wm+Mb4cQ=";

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
