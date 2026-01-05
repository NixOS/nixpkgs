{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  udev,
  coreutils,
}:

rustPlatform.buildRustPackage rec {
  pname = "surface-control";
  version = "0.4.10-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-control";
    tag = "v${version}";
    hash = "sha256-leWSSm1/gnZ9AuvpSU/p8mA48YBfyWg3CKlo2qW8/Hc=";
  };

  cargoHash = "sha256-hCG9P04fZo7K2ttcApz91SAm3Qq67FqcUNDxKOzIZX4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ udev ];

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/surface-*/out/surface.{bash,fish} \
      --zsh $releaseDir/build/surface-*/out/_surface
  '';

  meta = {
    description = "Control various aspects of Microsoft Surface devices on Linux from the Command-Line";
    homepage = "https://github.com/linux-surface/surface-control";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "surface";
  };
}
