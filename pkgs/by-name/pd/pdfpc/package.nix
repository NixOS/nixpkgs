{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  vala,
  gtk3,
  libgee,
  poppler,
  libpthread-stubs,
  gst_all_1,
  gobject-introspection,
  wrapGAppsHook3,
  qrencode,
  webkitgtk_4_1,
  discount,
  json-glib,
  nix-update-script,
  libsoup_3,
  librsvg,
}:

let
  inherit (gst_all_1)
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-libav
    ;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfpc";
  version = "4.7.0";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fPhCrn1ELC03/II+e021BUNJr1OKCBIcFCM7z+2Oo+s=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    vala
    # For setup hook
    gobject-introspection
    wrapGAppsHook3
  ];

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin (lib.cmakeBool "MDVIEW" false);
  buildInputs =
    let
      platformBuildInputs =
        if stdenv.hostPlatform.isDarwin then
          [ librsvg ]
        else
          [
            libpthread-stubs
            webkitgtk_4_1
          ];
    in
    [
      (gst-plugins-good.override { gtkSupport = true; })
      discount
      gst-libav
      gst-plugins-base
      gstreamer
      gtk3
      json-glib
      libgee
      libsoup_3
      poppler
      qrencode
    ]
    ++ platformBuildInputs;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Presenter console with multi-monitor support for PDF files";
    mainProgram = "pdfpc";
    homepage = "https://pdfpc.github.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
  };

})
