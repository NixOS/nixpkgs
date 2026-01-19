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
  version = "0.4.12-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-control";
    tag = "v${version}";
    hash = "sha256-SHueVZdughQ+EK2hcBYiYZIieQAQOkTc8b5uSOc6LOY=";
  };

  cargoHash = "sha256-KdlGlKCFnCFVUaeUV4YqPYEZ0zkVDqx/To9gMRs11y0=";

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
