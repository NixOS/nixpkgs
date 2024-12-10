{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  dbus,
  libseccomp,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "youki";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/cc+gHnakxC446MxErvgCDvc1gMWNi45h6fZ1Cd1Pj0=";
  };

  cargoPatches = [
    ./fix-cargo-lock.patch
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    dbus
    libseccomp
    systemd
  ];

  postInstall = ''
    installShellCompletion --cmd youki \
      --bash <($out/bin/youki completion -s bash) \
      --fish <($out/bin/youki completion -s fish) \
      --zsh <($out/bin/youki completion -s zsh)
  '';

  cargoBuildFlags = [
    "-p"
    "youki"
  ];
  cargoTestFlags = [
    "-p"
    "youki"
  ];

  cargoHash = "sha256-PKn448fOCnyMC42NtQnLt8kvZIBautsq4Fw/bRvwmpw=";

  meta = with lib; {
    description = "A container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    changelog = "https://github.com/containers/youki/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "youki";
  };
}
