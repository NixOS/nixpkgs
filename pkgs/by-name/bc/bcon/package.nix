{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  versionCheckHook,

  pkg-config,
  fontconfig,
  systemd,
  seatd,
  libxkbcommon,
  libgbm,
  libinput,
  libGL,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bcon";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "sanohiro";
    repo = "bcon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R5eoqlrIAnZiixvBVJYF2Hg/LcNr/KSlFOqD9BDngh8=";
  };

  cargoHash = "sha256-4dADjDaGAfnBSdz9RtHHSrBlRR2qmA993OYpvYfpCI0=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    versionCheckHook
  ];

  buildInputs = [
    fontconfig
    systemd
    seatd
    libxkbcommon
    libgbm
    libinput
    libGL
  ];

  postInstall = ''
    wrapProgram $out/bin/bcon \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
  '';

  doInstallCheck = true;

  meta = {
    description = "GPU-accelerated terminal emulator for Linux console (TTY)";
    homepage = "https://github.com/sanohiro/bcon";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "bcon";
    changelog = "https://github.com/sanohiro/bcon/blob/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.linux;
  };
})
