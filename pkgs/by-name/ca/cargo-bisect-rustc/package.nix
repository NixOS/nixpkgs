{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  runCommand,
  patchelf,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bisect-rustc";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "cargo-bisect-rustc";
    rev = "v${version}";
    hash = "sha256-7HiM1oRuLSfRaum66duag/w8ncFdxRLF0yeSGlIey0Y=";
  };

  patches =
    let
      patchelfPatch =
        runCommand "0001-dynamically-patchelf-binaries.patch"
          {
            CC = stdenv.cc;
            patchelf = patchelf;
            libPath = "$ORIGIN/../lib:${lib.makeLibraryPath [ zlib ]}";
          }
          ''
            export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
            substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
              --subst-var patchelf \
              --subst-var dynamicLinker \
              --subst-var libPath
          '';
    in
    lib.optionals stdenv.hostPlatform.isLinux [ patchelfPatch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-SigRm2ZC7jH1iCEGRpka1G/e9kBEieFVU0YDBl2LfTM=";

  checkFlags = [
    "--skip test_github" # requires internet
  ];

  meta = with lib; {
    description = "Bisects rustc, either nightlies or CI artifacts";
    mainProgram = "cargo-bisect-rustc";
    homepage = "https://github.com/rust-lang/cargo-bisect-rustc";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
