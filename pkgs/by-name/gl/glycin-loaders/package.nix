{
  stdenv,
  lib,
  fetchurl,
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

  makeSetupHook,
  bubblewrap,
  jq,
  moreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-Qccr4eybpV2pDIL8GFc7dC3/WCsJr8N7RWXEfpnMj/Q=";
  };

  nativeBuildInputs = [
    cargo
    git
    meson
    ninja
    pkg-config
    rustc
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

    patchHook = makeSetupHook {
      name = "glycin-loader-patch-hook";
      propagatedBuildInputs = [
        jq
        moreutils
      ];
      substitutions = {
        bwrap = lib.getExe bubblewrap;
        glycinloaders = finalAttrs.finalPackage;
      };
    } ./hook.sh;
  };

  meta = {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/sophie-h/glycin";
    maintainers = lib.teams.gnome.members;
    license = with lib.licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
