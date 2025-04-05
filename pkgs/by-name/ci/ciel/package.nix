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

rustPlatform.buildRustPackage rec {
  pname = "ciel";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "ciel-rs";
    tag = "v${version}";
    hash = "sha256-vV1qZLVVVc6KFZrpF4blKmbfQjf/Ltn+IhmM5Zqb2zU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-A52SV0Ng6exHEtlaZWBvVTEAqMKp6unQBhr1cozQTWo=";

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

  meta = with lib; {
    description = "Tool for controlling AOSC OS packaging environments using multi-layer filesystems and containers";
    homepage = "https://github.com/AOSC-Dev/ciel-rs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      A1ca7raz
      yisuidenghua
    ];
    mainProgram = "ciel";
  };
}
