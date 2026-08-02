{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  dbus,
  git,
  installShellFiles,
  libmnl,
  libnftnl,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mullvad";
  version = "2026.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvadvpn-app";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-1Q+i7W0T0Qst5ziO9St6Pcg0GgHQC+NGtRNmyA3A33g=";
  };

  cargoHash = "sha256-zcZjjAPiIfkbU1nKhjdxyWP6PvkLEUCNYwFzIzRXArE=";

  cargoBuildFlags =
    let
      makeTargets =
        targets:
        lib.flatten (
          map (
            attrOrStr:
            let
              target = attrOrStr.target or attrOrStr;
              binary = attrOrStr.binary or attrOrStr;
            in
            [
              "-p"
              target
              "--bin"
              binary
            ]
          ) targets
        );
    in
    makeTargets [
      {
        target = "mullvad-cli";
        binary = "mullvad";
      }
      "mullvad-daemon"
      "mullvad-setup"
      "mullvad-problem-report"
      "mullvad-exclude"
      "tunnel-obfuscation"
    ];

  nativeBuildInputs = [
    git
    installShellFiles
    pkg-config
    protobuf
  ];

  buildInputs = [
    rust-jemalloc-sys
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus.dev
    libmnl
    libnftnl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.libpcap
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    compdir=$(mktemp -d)
    for shell in bash zsh fish; do
      $out/bin/mullvad shell-completions $shell $compdir
    done
    installShellCompletion --cmd mullvad \
      --bash $compdir/mullvad.bash \
      --zsh $compdir/_mullvad \
      --fish $compdir/mullvad.fish
  '';

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.hasMullvadDaemon = true;

  meta = {
    description = "Mullvad VPN daemon and command-line interface";
    longDescription = "**NOTE:** This package does not contain the Mullvad VPN graphical interface. The GUI to manage the Mullvad daemon is available on `pkgs.mullvad-vpn`.";
    homepage = "https://mullvad.net/";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      cole-h
      jackr
      sigmasquadron
    ];
    mainProgram = "mullvad";
  };
})
