{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  feedbackd,
  gtk4,
  libdng,
  libepoxy,
  libmegapixels,
  libpulseaudio,
  xorg,
  zbar,
  tiffSupport ? true,
  libraw,
  jpgSupport ? true,
  graphicsmagick,
  exiftool,
}:

assert jpgSupport -> tiffSupport;

let
  inherit (lib)
    makeBinPath
    optional
    optionals
    optionalString
    ;
  runtimePath = makeBinPath (
    optional tiffSupport libraw
    ++ optionals jpgSupport [
      graphicsmagick
      exiftool
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "megapixels";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "megapixels-org";
    repo = "Megapixels";
    tag = finalAttrs.version;
    hash = "sha256-tuAMp92166WZJfGIEzEWal9BExzQJoYodd2uZHhqEuQ=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    feedbackd
    gtk4
    libdng
    libepoxy
    libmegapixels
    libpulseaudio
    xorg.libXrandr
    zbar
  ];

  patches = [
    # In the settings menu of Megapixels the user can select a different postprocessing script. The path to the script is then stored in a dconf setting. If the path changes, for example because it is in the Nix store and a dependency of the postprocessor changes, Megapixels will try to use this now non-existing old path. This will cause Megapixels to not save any images that were taken until the user opens the settings again and selects a postprocessor again. Using a global path allows the setting to keep working.
    # Note that this patch only fixes the issue for external postprocessors like postprocessd but the postprocessor script that comes with Megapixels is still referred to by the Nix store path.
    ./search-for-postprocessors-in-NixOS-specific-global-location.patch
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = optionalString (tiffSupport || jpgSupport) ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.escapeShellArg runtimePath}
    )
  '';

  strictDeps = true;

  meta = {
    description = "GTK4 camera application that knows how to deal with the media request api";
    homepage = "https://gitlab.com/megapixels-org/Megapixels";
    changelog = "https://gitlab.com/megapixels-org/Megapixels/-/tags/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      Luflosi
    ];
    platforms = lib.platforms.linux;
    mainProgram = "megapixels";
  };
})
