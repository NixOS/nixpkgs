{
  alsa-lib,
  fetchFromGitHub,
  lib,
  libGL,
  libxcb,
  libxkbcommon,
  pkg-config,
  rustPlatform,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fyrox-project-manager-unwrapped";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "FyroxEngine";
    repo = "Fyrox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hmqr4R2WpyqtI8hGk4Czqmp3x6TEuUBVD8rMVXBL9ho=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libGL
    libxcb
    libxkbcommon
    wayland
  ];

  buildAndTestSubdir = "project-manager";

  postInstall = ''
    install -Dm444 pics/logo.png $out/share/icons/hicolor/128x128/apps/fyrox.png
  '';

  passthru = {
    inherit (finalAttrs) buildInputs;
  };

  meta = {
    description = "3D and 2D game engine written in Rust";
    homepage = "https://fyrox.rs/";
    changelog = "https://github.com/FyroxEngine/Fyrox/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "fyrox-project-manager";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.linux;
  };
})
