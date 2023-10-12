{ lib, stdenv, fetchFromGitHub
, vala, cmake, ninja, wrapGAppsHook, pkg-config, gettext
, gobject-introspection, glib, gdk-pixbuf, gtk4, glib-networking
, libadwaita
, libnotify, libsoup, libgee
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

stdenv.mkDerivation rec {
  pname = "dino";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    rev = "v${version}";
    sha256 = "sha256-smy/t6wTCnG0kuRFKwyeLENKqOQDhL0fZTtj3BHo6kw=";
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
    wrapGAppsHook
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
    libsoup
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
    "-DVERSION_FULL=${version}"
  ];

  # Undefined symbols for architecture arm64: "_gpg_strerror"
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lgpg-error";

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
  postFixup = lib.optionalString (stdenv.isDarwin) ''
    cd "$out/lib/dino/plugins/"
    for f in *.dylib; do
      mv "$f" "$(basename "$f" .dylib).so"
    done
  '';

  meta = with lib; {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    homepage = "https://github.com/dino/dino";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ qyliss tomfitzhenry ];
  };
}
