{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  wrapGAppsNoGuiHook,
  gst_all_1,
  fontconfig,
  libglycin,
  glycin-loaders,
  writableTmpDirAsHomeHook,
  shared-mime-info,
  callPackage,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-thumbnailers";
  version = "1.1.alpha";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gst-thumbnailers";
    tag = finalAttrs.version;
    hash = "sha256-F66TgEzTb0Lg7Danyf9KCOset0ZpyGSKch8SKq8aKIs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-GGLNgEPb4N5AvETYJir9gsUK/+J+GbnupZQLnJ2rB2I=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    fontconfig
    libglycin
    glycin-loaders
  ];

  strictDeps = true;
  __structuredAttrs = true;

  doCheck = true;

  nativeCheckInputs = [
    # fontconfig tries to write to `~/.cache/fontconfig`
    writableTmpDirAsHomeHook
  ];

  # Fix missing glycin loaders (glycin-loaders) and incorrectly detected
  # MIME types (shared-mime-info).
  preCheck = ''
    export XDG_DATA_DIRS=${glycin-loaders}/share:${shared-mime-info}/share:$XDG_DATA_DIRS
  '';

  mesonCheckFlags = [ "-v" ];

  passthru = {
    tests.thumbnailers = callPackage ./tests.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate thumbnailer for video and audio files";
    homepage = "https://gitlab.gnome.org/GNOME/gst-thumbnailers";
    changelog = "https://gitlab.gnome.org/GNOME/gst-thumbnailers/-/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aleksana
      thunze
    ];
    platforms = lib.platforms.linux;
  };
})
