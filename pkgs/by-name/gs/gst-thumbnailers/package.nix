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
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
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
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gst-thumbnailers";
    tag = finalAttrs.version;
    hash = "sha256-LWQ8a4sMz3XalPuToSlOOWczqQsEwVs+UUEid+nTWO4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+smvLJ+Zz1uM39f6inZitJaz2CWKDwYOynJI00OPFSg=";
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
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
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
