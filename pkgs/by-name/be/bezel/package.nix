{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  udev,
  runtimeShell,
  libnotify,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bezel";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Indra55";
    repo = "bezel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6pItHoEZCJi7Zo89HGzLNqNX+JzM69xBaZbuB3vrPDI=";
  };

  cargoHash = "sha256-pClznWnPGJyP2j4Pn8M7dwtBgUXrA42GYvT54YSzXWE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  postPatch = ''
    substituteInPlace src/dispatcher.rs \
      --replace-fail '"sh"' '"${runtimeShell}"' \
      --replace-fail '"notify-send"' '"${lib.getExe' libnotify "notify-send"}"'
  '';

  postInstall = ''
    install -Dm644 config.toml.example \
      $out/share/bezel/config.toml.example
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux daemon for configurable trackpad edge gestures";
    homepage = "https://github.com/Indra55/bezel";
    changelog = "https://github.com/Indra55/bezel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.Indra55 ];
    mainProgram = "bezel";
    platforms = lib.platforms.linux;
  };
})
