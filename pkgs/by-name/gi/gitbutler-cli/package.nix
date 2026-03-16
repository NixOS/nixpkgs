{
  cmake,
  dbus,
  git,
  gitbutler,
  lib,
  libgit2,
  makeWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitbutler-cli";
  version = gitbutler.version;

  # Inherit source and cargo configuration from the gitbutler desktop app
  inherit (gitbutler) src cargoHash;

  # cargo-auditable fails because `but-db` uses `dep:tokio`
  # The gitbutler desktop package avoids it by using cargo-tauri instead.
  auditable = false;

  cargoBuildFlags = [
    "--package=but"
    "--package=gitbutler-git"
  ];

  cargoTestFlags =
    [
      "--package=but"
      "--"
    ]
    ++ lib.concatMap (test: [ "--skip=${test}" ]) gitbutler.skippedTests;

  nativeBuildInputs = [
    cmake # Required by `zlib-sys` crate
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux dbus;

  nativeCheckInputs = [ git ];

  postInstall = ''
    mkdir -p $out/libexec/gitbutler-cli
    mv $out/bin/but $out/libexec/gitbutler-cli/but
    mv $out/bin/gitbutler-git-askpass $out/libexec/gitbutler-cli/gitbutler-git-askpass
    mv $out/bin/gitbutler-git-setsid $out/libexec/gitbutler-cli/gitbutler-git-setsid
    makeWrapper $out/libexec/gitbutler-cli/but $out/bin/but
  '';

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";
    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = 1;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "gitbutler";
    extraArgs = [
      "--version-regex"
      "release/(.*)"
    ];
  };

  meta = {
    description = "Git client CLI tool for simultaneous branches on top of your existing workflow";
    homepage = "https://gitbutler.com";
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      getchoo
      techknowlogick
      cholli
    ];
    mainProgram = "but";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
