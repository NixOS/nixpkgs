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
  version = "0.5.1-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-control";
    tag = "v${version}";
    hash = "sha256-wywmxtBxE7NU9ANQ5Z8AaEvdA73kiCuG36GmqNPBcjo=";
  };

  cargoHash = "sha256-aiPbr4y2Ya4QhQNtiL0KDHo9MIE307ZaRDP2a+5r38U=";

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
