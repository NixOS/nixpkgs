{
  stdenv,
  lib,
  fetchurl,
  substituteAll,
  bubblewrap,
  cargo,
  git,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
  gtk4,
  cairo,
  libheif,
  libxml2,
  libseccomp,
  libjxl,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin-loaders/${lib.versions.majorMinor finalAttrs.version}/glycin-loaders-${finalAttrs.version}.tar.xz";
    hash = "sha256-0PAiRi/1VYVuheqUBHRHC7NrN8n/y8umOgP+XpVDcM8=";
  };

  patches = [
    # Fix paths in glycin library.
    # Not actually needed for this package since we are only building loaders
    # and this patch is relevant just to apps that use the loaders
    # but apply it here to ensure the patch continues to apply.
    finalAttrs.passthru.glycinPathsPatch
  ];

  nativeBuildInputs = [
    cargo
    git
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.bindgenHook # for libheif-sys
  ];

  buildInputs = [
    gtk4 # for GdkTexture
    cairo
    libheif
    libxml2 # for librsvg crate
    libseccomp
    libjxl
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "glycin-loaders";
    };

    glycinPathsPatch = substituteAll {
      src = ./fix-glycin-paths.patch;
      bwrap = "${bubblewrap}/bin/bwrap";
    };
  };

  meta = with lib; {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/sophie-h/glycin";
    maintainers = teams.gnome.members;
    license = with licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    platforms = platforms.linux;
  };
})
