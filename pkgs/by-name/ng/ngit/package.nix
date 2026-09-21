{
  cacert,
  fetchgit,
  git,
  lib,
  libgit2,
  libssh2,
  makeWrapper,
  ngit-grasp,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

let
  canRunChecks = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
# Git has honoured the config-scope environment variables mirrored by ngit
# since 2.32. The Windows package uses an external Git from PATH because
# nixpkgs' Git packages do not currently support a Windows host platform.
assert lib.assertMsg (
  !stdenv.hostPlatform.isUnix || lib.versionAtLeast git.version "2.32"
) "ngit requires Git 2.32 or newer for config-scope environment variables";

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ngit";
  version = "3.0.3";

  __structuredAttrs = true;

  # The integration tests start relay fixtures on loopback sockets.
  __darwinAllowLocalNetworking = true;

  src = fetchgit {
    url = "https://ngit.dev/ngit.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EjS0HAsRK8ARl4Km48qAunEY9bLha4DFbaaLax+SS8I=";
  };

  cargoHash = "sha256-aDUE2EdL3zL1SIyTgd3Ge5egH2vZh89+ZOVrIkQY4Eg=";

  postPatch = lib.optionalString stdenv.hostPlatform.isUnix ''
    # These fixtures create executable scripts after ordinary shebang patching.
    substituteInPlace src/lib/self_update.rs tests/installer_templates.rs \
      --replace-fail '#!/usr/bin/env bash' '#!${stdenv.shell}'
    substituteInPlace tests/remote_helper_launcher.rs \
      --replace-fail '#!/bin/sh' '#!${stdenv.shell}'
  '';

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.hostPlatform.isUnix [ makeWrapper ];

  buildInputs = [
    libgit2
    libssh2
    openssl
  ];

  # Use nixpkgs' security-maintained C libraries instead of the copies bundled
  # by libgit2-sys and libssh2-sys.
  env = {
    LIBGIT2_NO_VENDOR = "1";
    LIBSSH2_SYS_USE_PKG_CONFIG = "1";
    NGIT_GRASP_BIN = lib.optionalString (canRunChecks && stdenv.hostPlatform.isUnix) (
      lib.getExe ngit-grasp
    );
  };

  # git-remote-nostr is invoked by Git, so Git must be exposed in user
  # environments alongside ngit on Unix. Windows users must provide Git 2.32
  # or newer on PATH.
  propagatedUserEnvPkgs = lib.optionals stdenv.hostPlatform.isUnix [ git ];

  nativeCheckInputs = lib.optionals (canRunChecks && stdenv.hostPlatform.isUnix) [
    cacert
    git
    ngit-grasp
  ];

  # Windows target binaries cannot be executed by the cross-build worker.
  # Upstream CI provides Windows compilation and selected unit-test coverage;
  # Grasp-backed integration tests remain Unix-only.
  doCheck = stdenv.hostPlatform.isUnix;

  # Include the harness regression tests alongside ngit's integration suite.
  cargoTestFlags = [ "--workspace" ];

  # The isolated credential-file override is deliberately available only in
  # debug builds. Match upstream CI so the account integration tests use it.
  checkType = "debug";

  postInstall = lib.optionalString stdenv.hostPlatform.isUnix ''
    wrapProgram "$out/bin/ngit" \
      --prefix PATH : ${lib.makeBinPath [ git ]} \
      --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = stdenv.hostPlatform.isUnix;

  versionCheckProgram = "${placeholder "out"}/bin/ngit${stdenv.hostPlatform.extensions.executable}";

  postInstallCheck = ''
    "$out/bin/git-remote-nostr${stdenv.hostPlatform.extensions.executable}" --version
  '';

  meta = {
    description = "Git plugin for publishing repositories and managing pull requests over Nostr";
    homepage = "https://ngit.dev/ngit";
    changelog = "https://ngit.dev/ngit/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danconwaydev ];
    mainProgram = "ngit${stdenv.hostPlatform.extensions.executable}";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
