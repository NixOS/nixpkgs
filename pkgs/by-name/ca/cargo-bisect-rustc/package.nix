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
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bisect-rustc";
  version = "0.6.12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "cargo-bisect-rustc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-egNp51aBzFvfGGugvUkrtAtFZY+uuX2ICweLRw9xwbM=";
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

  cargoHash = "sha256-kJ/mLHBrp67U5RkVZrkCyFjWLLwHvuLTCSxDmG1n9l0=";

  checkFlags = [
    "--skip=test_github" # requires internet
    "--skip=cli_tests" # trycmd does not seem to work in nix's sandbox
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bisects rustc, either nightlies or CI artifacts";
    mainProgram = "cargo-bisect-rustc";
    homepage = "https://github.com/rust-lang/cargo-bisect-rustc";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
})
