{ stdenv
, lib
, fetchFromGitLab
, substituteAll
, bubblewrap
, cargo
, git
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, gtk4
, cairo
, libheif
, libxml2
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "sophie-h";
    repo = "glycin";
    rev = finalAttrs.version;
    hash = "sha256-XT3i0GQsLC2sMLHpaEzbItauX/8327wdlVt0/WHkCeo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "glycin-loaders-${finalAttrs.version}";
    hash = "sha256-HRBR+FWI87FCtDlJ3VvwT/7QFG/L7PYliX7mBYPy3aM=";
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
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    gtk4 # for GdkTexture
    cairo
    libheif
    libxml2 # for librsvg crate
  ];

  passthru = {
    updateScript = nix-update-script { };

    glycinPathsPatch = substituteAll {
      src = ./fix-glycin-paths.patch;
      bwrap = "${bubblewrap}/bin/bwrap";
    };
  };

  meta = with lib; {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/sophie-h/glycin";
    maintainers = teams.gnome.members;
    license = with licenses; [ mpl20 /* or */ lgpl21Plus ];
    platforms = platforms.linux;
  };
})
