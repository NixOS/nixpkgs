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
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "ciel-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1+LSu3K+GOqlHGYbJNHjWHzEnrVI/8rGq8uUPqDCLc=";
  };

  cargoHash = "sha256-ez+gm8sLqjcZznrvH776r1kFpeHADkA/b13zdO6UqiU=";

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
