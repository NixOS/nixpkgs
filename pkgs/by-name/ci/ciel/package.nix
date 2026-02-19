{
  lib,
  bash,
  dbus,
  fetchFromGitHub,
  installShellFiles,
  libgit2,
  libssh2,
  openssl,
  pkg-config,
  rustPlatform,
  systemd,
  xz,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ciel";
  version = "3.9.11";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "ciel-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x26qy9dtycu8aRwMi3BNo15jthde2OVnwumSCwVt32c=";
  };

  cargoHash = "sha256-gspNRky0cYBWPnev0RJoMwqE2aRXHRqGSM/MDEY1Pp4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  # ciel has plugins which is actually bash scripts.
  # Therefore, bash is required for plugins to work.
  buildInputs = [
    bash
    systemd
    dbus
    openssl
    libssh2
    libgit2
    xz
    zlib
  ];

  postInstall = ''
    mv -v "$out/bin/ciel-rs" "$out/bin/ciel"

    # From install-assets.sh
    install -Dm555 -t "$out/libexec/ciel-plugin" plugins/*

    # Install completions
    installShellCompletion --cmd ciel \
      --bash completions/ciel.bash \
      --fish completions/ciel.fish \
      --zsh completions/_ciel
  '';

  meta = {
    description = "Tool for controlling AOSC OS packaging environments using multi-layer filesystems and containers";
    homepage = "https://github.com/AOSC-Dev/ciel-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      A1ca7raz
      yisuidenghua
    ];
    mainProgram = "ciel";
  };
})
