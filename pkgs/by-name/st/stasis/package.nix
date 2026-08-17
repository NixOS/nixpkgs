{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  wayland,
  wayland-protocols,
  dbus,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stasis";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saltnpepper97";
    repo = "stasis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5p0r9ymR2YimorGEVFdjqYKaQTeqSY7dZleV3kghUIc=";
  };

  cargoHash = "sha256-pXu9TQ3LKzjvenHzFjPEhtEj0oEl7cplGBchBRHWAAo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-protocols
    dbus
  ];

  #There are no tests
  doCheck = false;

  postInstall = ''
    install -Dm644 assets/stasis.png $out/share/icons/hicolor/256x256/apps/stasis.png
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern idle manager for Wayland";
    longDescription = ''
      Stasis is a smart idle manager for Wayland that understands context.
      It automatically prevents idle when watching videos, reading documents,
      or playing music, while allowing idle when appropriate. Features include
      media-aware idle handling, application-specific inhibitors, Wayland idle
      inhibitor protocol support, and flexible configuration using the RUNE
      configuration language.
    '';
    homepage = "https://github.com/saltnpepper97/stasis";
    changelog = "https://github.com/saltnpepper97/stasis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    platforms = lib.platforms.linux;
    mainProgram = "stasis";
  };
})
