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
  version = "0.4.9-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-control";
    tag = "v${version}";
    hash = "sha256-CcLHaakWhrzfDrNoXGQom9LkdlkTUkTui7djn3m+vhI=";
  };

  cargoHash = "sha256-46JqH3FIO1zMeWqNEL8NcfU+Tiaanr99EBMjnr9tE+g=";

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
