{
  alsa-lib,
  fetchFromGitHub,
  fetchpatch2,
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

  cargoPatches = [
    (fetchpatch2 {
      name = "add-cargo-lock.patch";
      url = "https://github.com/EpicEric/Fyrox/commit/6bc6081f0fb45f56d02a24a8d6ed43a7d565f570.patch?full_index=1";
      hash = "sha256-q95sEEYKM/SE9yjbjbCX6cL4Bbosgz1kaIQa2gmVmD8=";
    })
  ];
  cargoHash = "sha256-B5MrrhXTfT+tyT93FTE3VM5Vk3bwqnLmJYlFtFE61Lw=";

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
