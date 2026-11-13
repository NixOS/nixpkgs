{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nasm,
  patchelf,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  dbus,
  libdrm,
  libgbm,
  libva,
  libxkbcommon,
  wayland,
  vulkan-loader,
  openssh,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gliff";
  version = "0.3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "gliff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7tE/Gsf3RkeSKqESn+6GMq0vZpZA1miWH3pUiyqUs3E=";
  };

  cargoHash = "sha256-dZ6DVDGyvrWpORgE87EUfZjVHh7JS6UiSRWHojLeCXA=";

  nativeBuildInputs = [
    pkg-config
    nasm
    patchelf
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    dbus
    libdrm
    libgbm
    libva
    libxkbcommon
    wayland
  ];

  # The server is invoked per connection over SSH, not as a resident service.
  # Omarchy's remote-session probe uses pgrep -x gliff-server. Wrapping the
  # server would rename its ELF to .gliff-server-wrapped and hide it from
  # that probe, so only the GTK client gets the application wrapper.
  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
    )
  '';

  postInstall = ''
    install -Dm644 pkgbuild/gliff.desktop "$out/share/applications/gliff.desktop"
    install -Dm644 pkgbuild/gliff.svg "$out/share/icons/hicolor/scalable/apps/gliff.svg"
    install -Dm644 LICENSE "$out/share/licenses/gliff/LICENSE"
    install -Dm644 NOTICE "$out/share/licenses/gliff/NOTICE"
    install -Dm644 README.md "$out/share/doc/gliff/README.md"
    install -Dm644 docs/hardware-quirks.md "$out/share/doc/gliff/hardware-quirks.md"
  '';

  postFixup = ''
    wrapGApp "$out/bin/gliff"
    for program in gliff-server gliff-probe; do
      patchelf --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]} "$out/bin/$program"
    done
  '';

  meta = {
    description = "Remote desktop client and server for Hyprland over SSH";
    homepage = "https://github.com/omacom/gliff";
    license = with lib.licenses; [
      mit
      bsd2
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gliff";
  };
})
