{ lib, stdenv, fetchFromGitHub
, buildPackages
, vala, cmake, ninja, wrapGAppsHook4, pkg-config, gettext
, gobject-introspection, glib, gdk-pixbuf, gtk4, glib-networking
, libadwaita
, libnotify, libsoup_2_4, libgee
, libsignal-protocol-c
, libgcrypt
, sqlite
, gpgme
, pcre2
, qrencode
, icu
, gspell
, srtp
, libnice
, gnutls
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-plugins-bad
, gst-vaapi
, webrtc-audio-processing
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dino";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-I0ASeEjdXyxhz52QisU0q8mIBTKMfjaspJbxRIyOhD4=";
  };

  postPatch = ''
    # don't overwrite manually set version information
    substituteInPlace CMakeLists.txt \
      --replace "include(ComputeVersion)" ""
  '';

  nativeBuildInputs = [
    vala
    cmake
    ninja # https://github.com/dino/dino/issues/230
    pkg-config
    wrapGAppsHook4
    gettext
    gobject-introspection
  ];

  buildInputs = [
    qrencode
    glib
    glib-networking # required for TLS support
    libadwaita
    libgee
    sqlite
    gdk-pixbuf
    gtk4
    libnotify
    gpgme
    libgcrypt
    libsoup_2_4
    pcre2
    icu
    libsignal-protocol-c
    gspell
    srtp
    libnice
    gnutls
    gstreamer
    gst-plugins-base
    gst-plugins-good # contains rtpbin, required for VP9
    gst-plugins-bad # required for H264, MSDK
    gst-vaapi # required for VAAPI
    webrtc-audio-processing
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=true"
    "-DRTP_ENABLE_H264=true"
    "-DRTP_ENABLE_MSDK=true"
    "-DRTP_ENABLE_VAAPI=true"
    "-DRTP_ENABLE_VP9=true"
    "-DVERSION_FOUND=true"
    "-DVERSION_IS_RELEASE=true"
    "-DVERSION_FULL=${finalAttrs.version}"
    "-DXGETTEXT_EXECUTABLE=${lib.getBin buildPackages.gettext}/bin/xgettext"
    "-DMSGFMT_EXECUTABLE=${lib.getBin buildPackages.gettext}/bin/msgfmt"
    "-DGLIB_COMPILE_RESOURCES_EXECUTABLE=${lib.getDev buildPackages.glib}/bin/glib-compile-resources"
    "-DSOUP_VERSION=${lib.versions.major libsoup_2_4.version}"
  ];

  # Undefined symbols for architecture arm64: "_gpg_strerror"
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lgpg-error";

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./xmpp-vala-test
    ./signal-protocol-vala-test
    runHook postCheck
  '';

  # Dino looks for plugins with a .so filename extension, even on macOS where
  # .dylib is appropriate, and despite the fact that it builds said plugins with
  # that as their filename extension
  #
  # Therefore, on macOS rename all of the plugins to use correct names that Dino
  # will load
  #
  # See https://github.com/dino/dino/wiki/macOS
  postFixup = lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    cd "$out/lib/dino/plugins/"
    for f in *.dylib; do
      mv "$f" "$(basename "$f" .dylib).so"
    done
  '';

  meta = with lib; {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    mainProgram = "dino";
    homepage = "https://github.com/dino/dino";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ qyliss tomfitzhenry ];
  };
})
