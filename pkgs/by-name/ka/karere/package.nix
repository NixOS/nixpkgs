{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  libadwaita,
  webkitgtk_6_0,
  glib-networking,
  gst_all_1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karere";
  version = "3.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tobagin";
    repo = "karere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VJGTpkMkYKvU/I/DoyBMD9deciLzmrs48If1wQutvnE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-48ai2Jf/Uo+sXsT78v4usVEAn1zV/YVz4FZZs2ZZDa8=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    webkitgtk_6_0
    glib-networking
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --set FLATPAK_ID io.github.tobagin.karere
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gtk4 Whatsapp client";
    homepage = "https://github.com/tobagin/karere";
    changelog = "https://github.com/tobagin/karere/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      marcel
      aleksana
    ];
    mainProgram = "karere";
  };
})
