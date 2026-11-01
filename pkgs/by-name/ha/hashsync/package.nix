{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  bashNonInteractive,
  rsync,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hashsync";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "someplaceguy";
    repo = "hashsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FLYlcVK3FvcO6Tz4HiHcCJd0Q+gQMOyBaUBdouovyRw=";
  };

  cargoHash = "sha256-jmC2xGcMvnuytf0XMxv4Vi83+NCMu0HGtzFSpdzjc7o=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    # librocksdb-sys generates its bindings to RocksDB with bindgen.
    rustPlatform.bindgenHook
  ];

  # patchShebangs points the `#!/usr/bin/env bash` of hashsync-copy-closure
  # at this bash. With strictDeps, it only looks for interpreters in
  # buildInputs.
  buildInputs = [ bashNonInteractive ];

  # Rust links static binaries as static PIEs, which fails with the static
  # libstdc++ of nixpkgs, because that library isn't position independent.
  # This variable adds to the flags that the Cargo configuration of nixpkgs
  # gives the target, which RUSTFLAGS would replace.
  env = lib.optionalAttrs stdenv.hostPlatform.isStatic {
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
      "-C relocation-model=static";
  };

  # The transfer tests run rsync with `hashsync ssh` as its remote shell.
  nativeCheckInputs = [ rsync ];

  checkFlags = [
    # This test compares docs/hashsync.adoc, which isn't installed, with what
    # pandoc makes of the man page, so its result depends on the version of
    # pandoc.
    "--skip=tests::the_asciidoc_page_matches_the_man_page"
  ];

  postInstall = ''
    installManPage docs/hashsync.1

    # hashsync-copy-closure runs the hashsync in the PATH. The wrapper puts the
    # hashsync of this package first, but only on this host: with both --from
    # and --to, the destination runs the functions of the script with its own
    # PATH. The script stays out of bin so that its usage message shows its
    # name, not the name of a wrapped file.
    install -Dm755 extras/hashsync-copy-closure.sh \
      $out/libexec/hashsync/hashsync-copy-closure
    makeWrapper $out/libexec/hashsync/hashsync-copy-closure \
      $out/bin/hashsync-copy-closure --prefix PATH : $out/bin

    # The licenses of the bundled code require their notices to come with the
    # binary, and the Apache License requires its text to come with
    # hashsync-copy-closure.
    install -Dm644 -t $out/share/doc/hashsync COPYING THIRD-PARTY-NOTICES \
      extras/LICENSE-Apache-2.0
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run a command over SSH, deduplicating its output or input against indexed files";
    homepage = "https://github.com/someplaceguy/hashsync";
    changelog = "https://github.com/someplaceguy/hashsync/releases/tag/${finalAttrs.src.tag}";
    # hashsync-copy-closure is under the Apache License 2.0.
    license = [
      lib.licenses.gpl3Plus
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ someplaceguy ];
    mainProgram = "hashsync";
    platforms = lib.platforms.linux;
  };
})
