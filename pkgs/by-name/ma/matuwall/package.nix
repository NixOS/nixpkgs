{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  versionCheckHook,
  nix-update-script,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libpng,
  libjpeg_turbo,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matuwall";
  version = "0.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "naurissteins";
    repo = "Matuwall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oTiojaIBfTxOWDRu4mckEwpvd040Gg4oeFWw20C6kd4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libpng
    libjpeg_turbo
    libwebp
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and lightweight wallpaper picker for Wayland";
    homepage = "https://github.com/naurissteins/Matuwall";
    changelog = "https://github.com/naurissteins/Matuwall/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ naurissteins ];
    platforms = lib.platforms.linux;
    mainProgram = "matuwall";
  };
})
