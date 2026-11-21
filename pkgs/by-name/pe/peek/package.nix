{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  meson,
  ninja,
  gettext,
  desktop-file-utils,
  appstream-glib,
  pkg-config,
  txt2man,
  vala,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gtk3,
  glib,
  cairo,
  keybinder3,
  ffmpeg-full,
  python3,
  libxml2,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  which,
  gifski,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "peek";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = finalAttrs.version;
    sha256 = "1xwlfizga6hvjqq127py8vabaphsny928ar7mwqj9cyqfl6fx41x";
  };

  patches = [
    # Fix compatibility with GNOME Shell ≥ 40.
    # https://github.com/phw/peek/pull/910
    (fetchpatch {
      url = "https://github.com/phw/peek/commit/008d15316ab5428363c512b263ca8138cb8f52ba.patch";
      sha256 = "xxJ+r5uRk93MEzWTFla88ewZsnUl3+YKTenzDygtKP0=";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    libxml2
    pkg-config
    txt2man
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    glib
    gsettings-desktop-schemas
    gtk3
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    keybinder3
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py data/man/build_man.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        which
        ffmpeg-full
        gifski
      ]
    })
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/phw/peek";
    description = "Simple animated GIF screen recorder with an easy to use interface";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = lib.platforms.linux;
    mainProgram = "peek";
  };
})
