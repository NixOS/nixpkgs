{
  lib,
  stdenv,
  fetchurl,
  dbus-glib,
  libxml2,
  sqlite,
  telepathy-glib,
  python3,
  pkg-config,
  dconf,
  makeWrapper,
  intltool,
  libxslt,
  gobject-introspection,
  dbus,
  fetchpatch,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "telepathy-logger";
  version = "0.8.2";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-${version}.tar.bz2";
    sha256 = "1bjx85k7jyfi5pvl765fzc7q2iz9va51anrc2djv7caksqsdbjlg";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-packages/raw/2b5bdbb4739d3517f5e7300edc8dab775743b96d/trunk/0001-tools-Fix-the-build-with-Python-3.patch";
      hash = "sha256-o1lfdZIIqaxn7ntQZnoOMqquc6efTHgSIxB5dpFWRgg=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    intltool
    libxslt
    gobject-introspection
    python3
  ];
  buildInputs =
    [
      dbus-glib
      libxml2
      sqlite
      telepathy-glib
      dbus
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.Foundation
    ];

  configureFlags = [ "--enable-call" ];

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-logger" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    description = "Logger service for Telepathy framework";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-logger/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
