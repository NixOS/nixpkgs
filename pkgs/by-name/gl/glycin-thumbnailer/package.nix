{
  lib,
  stdenv,
  callPackage,
  cargo,
  fontconfig,
  glib,
  glycin-loaders,
  libglycin,
  libseccomp,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
  wrapGAppsNoGuiHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-thumbnailer";

  inherit (libglycin) version src cargoDeps;

  nativeBuildInputs = [
    cargo
    libglycin.patchVendorHook
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    fontconfig
    glib
    glycin-loaders
    libglycin.setupHook
    libseccomp
  ];

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "glycin-thumbnailer" true)
    (lib.mesonBool "libglycin" false)
    (lib.mesonBool "libglycin-gtk4" false)
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # Thumbnailer files are in `glycin-loaders`, but we provide them in this package
  postInstall = ''
    mkdir -p $out/share/thumbnailers
    (
      shopt -s failglob

      for thumbnailer in ../glycin-loaders/glycin-*/glycin-*.thumbnailer.in; do
        substitute "$thumbnailer" "$out/share/thumbnailers/$(basename "''${thumbnailer%.in}")" \
          --subst-var-by "BINDIR" "$out/bin"
      done
    )
  '';

  passthru.tests.thumbnailer = callPackage ./tests.nix { };

  meta = {
    description = "Glycin thumbnailers for several formats";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    changelog = "https://gitlab.gnome.org/GNOME/glycin/-/tags/${finalAttrs.version}";
    license = with lib.licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ thunze ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    mainProgram = "glycin-thumbnailer";
  };
})
