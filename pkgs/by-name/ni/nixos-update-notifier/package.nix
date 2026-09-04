{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  gsettings-desktop-schemas,
  coreutils,
  makeBinaryWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixos-update-notifier";
  version = "0.9.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stuckj";
    repo = "nixos-update-notifier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mj+y1fu9TohFLqNY6K1U0cB0uQULObZwXFfhBPqFpr4=";
  };

  cargoHash = "sha256-bwmg0mv8MhdPfwz5MJNbO9/Eiy/EK+RiNgBJe8YyY8s=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    makeBinaryWrapper
  ];

  buildInputs = [
    glib
    gtk4
    gsettings-desktop-schemas
  ];

  dontWrapGApps = true;

  postInstall = ''
    install -Dm644 $src/share/applications/nixos-update-notifier.desktop \
      $out/share/applications/nixos-update-notifier.desktop
  '';

  postFixup = ''
    wrapProgram $out/bin/nixos-update-notifier-gtk \
      "''${gappsWrapperArgs[@]}"

    wrapProgram $out/bin/nixos-update-notifier \
      --suffix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System-tray update notifier for flake-based NixOS systems";
    homepage = "https://github.com/stuckj/nixos-update-notifier";
    license = lib.licenses.mit;
    mainProgram = "nixos-update-notifier";
    maintainers = with lib.maintainers; [ stuckj ];
    platforms = lib.platforms.linux;
  };
})
