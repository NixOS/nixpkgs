{ stdenv, lib, runCommand, patchelf, makeWrapper, pkg-config, curl, runtimeShell
, openssl, zlib, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "elan";
    rev = "v${version}";
    sha256 = "sha256-+GCmPT7dtd+XvmJv19XllZ6G4rB0+CYUt+lorr44aEQ=";
  };

  cargoHash = "sha256-iWZutcYyBVujwjMHFUwwE/xDk6o5tPng1ZQ2mHgTbVk=";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  OPENSSL_NO_VENDOR = 1;
  buildInputs = [ curl zlib openssl ]
    ++ lib.optional stdenv.isDarwin libiconv;

  buildFeatures = [ "no-self-update" ];

  patches = lib.optionals stdenv.isLinux [
    # Run patchelf on the downloaded binaries.
    # This is necessary because Lean 4 is now dynamically linked.
    (runCommand "0001-dynamically-patchelf-binaries.patch" {
        CC = stdenv.cc;
        cc = "${stdenv.cc}/bin/cc";
        ar = "${stdenv.cc}/bin/ar";
        patchelf = patchelf;
        shell = runtimeShell;
      } ''
     export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
     substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
       --subst-var patchelf \
       --subst-var dynamicLinker \
       --subst-var cc \
       --subst-var ar \
       --subst-var shell
    '')
  ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker leanc leanmake lake; do
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
    homepage = "https://github.com/leanprover/elan";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
  };
}
