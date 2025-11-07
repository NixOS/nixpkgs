{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  gpgme,
  installShellFiles,
  pkg-config,
  python3,
  writableTmpDirAsHomeHook,

  # buildInputs
  libgpg-error,
  nettle,
  openssl,
  xorg,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.7.0";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-j98X/+UTea4lCtFfMpClnfcKlvxm4DpOujLc0xc3VUY=";
  };

  cargoHash = "sha256-4/87+SOUXLoOxd3a4Kptxa98mh/BWlEhK55uu7+Jrec=";

  patches = [
    ./fix-tests.patch
  ];

  cargoBuildFlags = [ "-p ripasso-cursive" ];

  nativeBuildInputs = [
    gpgme
    installShellFiles
    pkg-config
    python3
    rustPlatform.bindgenHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    gpgme
    libgpg-error
    nettle
    openssl
    xorg.libxcb
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails in the darwin sandbox with:
    # Attempted to create a NULL object.
    # event loop thread panicked
    "--skip=pass::pass_tests::test_add_recipient_not_in_key_ring"
  ];

  postInstall = ''
    installManPage target/man-page/cursive/ripasso-cursive.1
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple password manager written in Rust";
    mainProgram = "ripasso-cursive";
    homepage = "https://github.com/cortex/ripasso";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sgo ];
    platforms = lib.platforms.unix;
  };
})
