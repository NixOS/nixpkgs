{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  pkg-config,
  makeBinaryWrapper,
  runtimeShell,
  libxkbcommon,
  wayland,
  vulkan-loader,
  systemd,
  xdg-utils,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hokum";
  version = "0.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "hokum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+CS6Rq3lQsli+F7GR56vejJfkHFWRI+dJV7AnWkMs60=";
  };

  cargoHash = "sha256-r3vn64VQ0CezL+j8VUckrdNkhPxPs4Z9Q/J0jOtqNLo=";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    libxkbcommon
    wayland
  ];

  # Rune loads these libraries with dlopen rather than linking against them.
  runtimeDependencies = [
    wayland
    vulkan-loader
  ];

  desktopItems = [ "packaging/hokum.desktop" ];

  postPatch = ''
    # Use store paths for D-Bus and systemd activation, including the shell condition.
    substituteInPlace packaging/hokum.service \
      --replace-fail /bin/sh ${runtimeShell} \
      --replace-fail /usr/bin/hokum $out/bin/hokum
    substituteInPlace packaging/app.hokum.Notifications.service \
      --replace-fail /usr/bin/hokum $out/bin/hokum

    substituteInPlace src/main.rs src/update.rs \
      --replace-fail 'Command::new("systemctl")' 'Command::new("${lib.getExe' systemd "systemctl"}")'
  '';

  postInstall = ''
    install -Dm644 packaging/hokum.service $out/lib/systemd/user/hokum.service
    install -Dm644 packaging/app.hokum.Notifications.service \
      $out/share/dbus-1/services/app.hokum.Notifications.service

    wrapProgram $out/bin/hokum \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  passthru.updateScript = nix-update-script {
    # Track stable releases, not the development channel.
    extraArgs = [
      "--version-regex"
      "v([0-9]+[.][0-9]+[.][0-9]+)"
    ];
  };

  meta = {
    description = "Freedesktop notification daemon for Wayland, drawn with Rune";
    homepage = "https://hokum.app";
    changelog = "https://github.com/anomalyco/hokum/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtvillafana ];
    mainProgram = "hokum";
    platforms = lib.platforms.linux;
  };
})
