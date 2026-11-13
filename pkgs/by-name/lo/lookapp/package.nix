{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  libxcb,
  libxau,
  libxdmcp,
  wayland,
  vulkan-loader,
  libglvnd,
  alsa-lib,
  fontconfig,
  freetype,
  xdg-utils,
  curl,
  procps,
  glib,
  sqlite,
}:

let
  # Opened at runtime, never linked: wgpu loads the Vulkan loader and GL,
  # gpui's Wayland and X11 clients load the rest. An rpath keeps them out of
  # the environment of every app Look launches.
  runtimeLibs = [
    vulkan-loader
    libglvnd
    wayland
    libxkbcommon
    libxcb
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lookapp";
  version = "0.7.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kunkka19xx";
    repo = "look";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qQAsNjgBkmhFgdNh40TLBWOcywu4wnE0cE4t2XFbQQ=";
  };

  cargoRoot = "apps/linows";
  buildAndTestSubdir = "apps/linows/gpui";

  cargoHash = "sha256-HjbaMHNkbCJNNT7HTBt/Wxv8HP1kb92HwPcb82PSq7U=";

  # The workspace version lags the tag; a release takes it from here.
  env.LOOK_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    libxkbcommon
    libxcb
    libxau
    libxdmcp
    alsa-lib
    fontconfig
    freetype
    sqlite
  ];

  postInstall = ''
    install -Dm644 $src/packaging/linux/lookapp.desktop \
      -t $out/share/applications
    for size in 32 64 128; do
      install -Dm644 $src/apps/linows/icons/''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/lookapp.png
    done
    install -Dm644 $src/apps/linows/icons/128x128@2x.png \
      $out/share/icons/hicolor/256x256/apps/lookapp.png
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/lookapp
    wrapProgram $out/bin/lookapp \
      --prefix PATH : ${
        lib.makeBinPath [
          xdg-utils
          fontconfig
          curl
          procps
          # gdbus backs the Wayland hotkey registration.
          glib
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-first, local-first desktop launcher";
    homepage = "https://github.com/kunkka19xx/look";
    changelog = "https://github.com/kunkka19xx/look/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lookapp";

    maintainers = [
      lib.maintainers.Teamofeyy
      lib.maintainers.kunkka19xx
    ];
  };
})
