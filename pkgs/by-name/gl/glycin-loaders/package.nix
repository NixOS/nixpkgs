{
  stdenv,
  lib,
  fetchurl,
  substituteAll,
  bubblewrap,
  cairo,
  cargo,
  git,
  gnome,
  gtk4,
  lcms2,
  libheif,
  libjxl,
  librsvg,
  libseccomp,
  libxml2,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-Vg7kIWfB7SKCZhjmHYPkkUDbW/R6Zam6js4s1z0qSqg=";
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
    lcms2
    libheif
    libxml2 # for librsvg crate
    librsvg
    libseccomp
    libjxl
  ];

  mesonFlags = [
    "-Dglycin-loaders=true"
    "-Dlibglycin=false"
    "-Dvapi=false"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "glycin-loaders";
      packageName = "glycin";
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
