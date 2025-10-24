{
  stdenv,
  lib,
  runCommand,
  patchelf,
  makeBinaryWrapper,
  pkg-config,
  curl,
  runtimeShell,
  openssl,
  zlib,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "elan";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "elan";
    rev = "v${version}";
    hash = "sha256-1pEa3uFO1lncCjOHEDM84A0p6xoOfZnU+OCS2j8cCK8=";
  };

  cargoHash = "sha256-CLeFXpCfaTTgbr6jmUmewArKfkOquNhjlIlwtoaJfZw=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    writableTmpDirAsHomeHook
  ];

  OPENSSL_NO_VENDOR = 1;
  buildInputs = [
    curl
    zlib
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  buildFeatures = [ "no-self-update" ];

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    # Run patchelf on the downloaded binaries.
    # This is necessary because Lean 4 is now dynamically linked.
    (runCommand "0001-dynamically-patchelf-binaries.patch"
      {
        CC = stdenv.cc;
        cc = "${stdenv.cc}/bin/cc";
        ar = "${stdenv.cc}/bin/ar";
        patchelf = patchelf;
        shell = runtimeShell;
      }
      ''
        export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
        substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
          --subst-var patchelf \
          --subst-var dynamicLinker \
          --subst-var cc \
          --subst-var ar \
          --subst-var shell
      ''
    )
  ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker leanc leanmake lake; do
      ln -s elan $link
    done
    popd

    # tries to create .elan
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/elan completions bash > "$out/share/bash-completion/completions/elan"
    $out/bin/elan completions fish > "$out/share/fish/vendor_completions.d/elan.fish"
    $out/bin/elan completions zsh >  "$out/share/zsh/site-functions/_elan"

    # https://github.com/NixOS/nixpkgs/blob/cae2bb97b01c4c77849e46a41a22e0a62926fc0f/pkgs/development/tools/rust/rustup/default.nix#L131-L140
    mkdir -p $out/nix-support
    substituteAll ${../../../build-support/wrapper-common/utils.bash} $out/nix-support/utils.bash
    substituteAll ${../../../build-support/wrapper-common/darwin-sdk-setup.bash} $out/nix-support/darwin-sdk-setup.bash
    substituteAll ${../../../build-support/bintools-wrapper/add-flags.sh} $out/nix-support/add-flags.sh
    substituteAll ${../../../build-support/bintools-wrapper/add-hardening.sh} $out/nix-support/add-hardening.sh
    export prog='$PROG'
    export use_response_file_by_default=0
    substituteAll ${../../../build-support/bintools-wrapper/ld-wrapper.sh} $out/nix-support/ld-wrapper.sh
    chmod +x $out/nix-support/ld-wrapper.sh

    # Ensure that the ld.lld wrapper sets the interpreter path, not clang.
    touch $out/nix-support/ld-set-dynamic-linker
    cp ${stdenv.cc}/nix-support/dynamic-linker $out/nix-support/dynamic-linker
    sed -i 's|extraBefore+=("-dynamic-linker"|extraAfter+=("-dynamic-linker"|' $out/nix-support/ld-wrapper.sh
  '';

  # https://github.com/NixOS/nixpkgs/blob/cae2bb97b01c4c77849e46a41a22e0a62926fc0f/pkgs/development/tools/rust/rustup/default.nix#L143-L152
  env = {
    inherit (stdenv.cc.bintools)
      expandResponseParams
      shell
      suffixSalt
      wrapperName
      coreutils_bin
      ;
    hardening_unsupported_flags = "";
  };

  meta = {
    description = "Small tool to manage your installations of the Lean theorem prover";
    homepage = "https://github.com/leanprover/elan";
    changelog = "https://github.com/leanprover/elan/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "elan";
  };
}
