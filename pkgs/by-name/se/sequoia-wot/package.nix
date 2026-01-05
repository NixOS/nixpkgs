{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  installShellFiles,
  pkg-config,
  nettle,
  openssl,
  sqlite,
  gnupg,
}:
rustPlatform.buildRustPackage rec {
  pname = "sequoia-wot";
  version = "0.12.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-wot";
    rev = "v${version}";
    hash = "sha256-Xbj1XLZQxyEYf/+R5e6EJMmL0C5ohfwZMZPVK5PwmUU=";
  };

  cargoHash = "sha256-hpI791Bz0MqZgjI2E/KMseqfPQU56Qr0xmHigyPv4HU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
  ]
  ++ lib.optionals (!stdenv.targetPlatform.isWindows) [
    nettle
  ];

  buildFeatures = [
    # Upstream uses the sequoia-openpgp crate, which doesn't force you to use a
    # specific crypto backend. As recommended by sequoia-openpgp's crate
    # docs[1], upstream uses `target.'cfg(not(windows))'.dev-dependencies` to
    # choose a different backend when the target platform is Windows or not. We
    # propagate this logic here as well.
    #
    # [1]: https://crates.io/crates/sequoia-openpgp#user-content-intermediate-crate
    (
      if stdenv.targetPlatform.isWindows then
        "sequoia-openpgp/crypto-cng"
      else
        "sequoia-openpgp/crypto-nettle"
    )
  ];

  doCheck = true;

  nativeCheckInputs = [ gnupg ];

  # Install shell completion files and manual pages. Unfortunately it is hard to
  # predict the paths to all of these files generated during the build, and it
  # is impossible to control these using `$OUT_DIR` or alike, as implied by
  # upstream's `build.rs`. This is a general Rust issue also discussed in
  # https://github.com/rust-lang/cargo/issues/9661, also discussed upstream at:
  # https://gitlab.com/sequoia-pgp/sequoia-wot/-/issues/56
  postInstall = ''
    installShellCompletion --cmd sq-wot \
      --bash target/*/release/build/sequoia-wot-*/out/sq-wot.bash \
      --fish target/*/release/build/sequoia-wot-*/out/sq-wot.fish \
      --zsh  target/*/release/build/sequoia-wot-*/out/_sq-wot
    # Also elv and powershell are generated there
    installManPage \
      target/*/release/build/sequoia-wot-*/out/sq-wot.1 \
      target/*/release/build/sequoia-wot-*/out/sq-wot-authenticate.1 \
      target/*/release/build/sequoia-wot-*/out/sq-wot-lookup.1 \
      target/*/release/build/sequoia-wot-*/out/sq-wot-identify.1 \
      target/*/release/build/sequoia-wot-*/out/sq-wot-list.1 \
      target/*/release/build/sequoia-wot-*/out/sq-wot-path.1
  '';

  meta = {
    description = "Rust CLI tool for authenticating bindings and exploring a web of trust";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-wot";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      doronbehar
      Cryolitia
    ];
    mainProgram = "sq-wot";
  };
}
