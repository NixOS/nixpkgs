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
  libepoxy,
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
  version = "1.8.2";

  src = fetchFromGitLab {
    owner = "megapixels-org";
    repo = "Megapixels";
    rev = finalAttrs.version;
    hash = "sha256-odsOYrk//ZhodsumLpJjhPDcwF1gkE/no166u+IDxSY=";
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
    libepoxy
    xorg.libXrandr
    zbar
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

  meta = with lib; {
    description = "GTK4 camera application that knows how to deal with the media request api";
    homepage = "https://gitlab.com/megapixels-org/Megapixels";
    changelog = "https://gitlab.com/megapixels-org/Megapixels/-/tags/${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      dotlambda
      Luflosi
    ];
    platforms = platforms.linux;
    mainProgram = "megapixels";
  };
})
