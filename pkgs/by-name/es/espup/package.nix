{
  lib,
  runCommand,
  rustPlatform,
  fetchFromGitHub,
  patchelf,
  pkg-config,
  installShellFiles,
  makeBinaryWrapper,
  bzip2,
  openssl,
  xz,
  zlib,
  zstd,
  stdenv,
  testers,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

let
  libPath = lib.makeLibraryPath [
    zlib # libz.so.1
    stdenv.cc.cc.lib # libstdc++.so.6
  ];
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "espup";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-blEjUFBzkwplwZgTAtI84MCHvxujNF1WsPJJezRNjxQ=";
  };

  cargoHash = "sha256-Y6Y+62lJ3k6GMkU82CDkTt1Prd3UrtBKqA5Spctochw=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    installShellFiles
  ];

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    (runCommand "0001-dynamically-patchelf-binaries.patch"
      {
        CC = stdenv.cc;
        patchelf = patchelf;
        libPath = "${libPath}";
      }
      ''
        export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
        substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
          --subst-var patchelf \
          --subst-var dynamicLinker \
          --subst-var libPath
      ''
    )
  ];

  buildInputs = [
    bzip2
    openssl
    xz
    zlib
    zstd
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = [
    # makes network calls
    "--skip=toolchain::rust::tests::test_xtensa_rust_parse_version"
  ];

  postInstall = ''
    wrapProgram $out/bin/espup --prefix "LD_LIBRARY_PATH" : "${libPath}"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd espup \
      --bash <($out/bin/espup completions bash) \
      --fish <($out/bin/espup completions fish) \
      --zsh <($out/bin/espup completions zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Tool for installing and maintaining Espressif Rust ecosystem";
    homepage = "https://github.com/esp-rs/espup/";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      knightpp
      beeb
    ];
    mainProgram = "espup";
  };
})
