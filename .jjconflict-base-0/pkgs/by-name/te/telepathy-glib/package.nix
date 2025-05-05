{
  lib,
  stdenv,
  fetchurl,
  dbus-glib,
  glib,
  python3,
  pkg-config,
  libxslt,
  gobject-introspection,
  vala,
  glibcLocales,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "telepathy-glib";
  version = "0.24.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${pname}-${version}.tar.gz";
    sha256 = "sKN013HN0IESXzjDq9B5ZXZCMBxxpUPVVeK/IZGSc/A=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    libxslt
    gobject-introspection
    vala
    python3
  ];

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    dbus-glib
    glib
  ];

  configureFlags = [
    "--enable-vala-bindings"
  ];

  LC_ALL = "en_US.UTF-8";

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace telepathy-glib/telepathy-glib.pc.in --replace Requires.private Requires
  '';

  patches = [
    # Upstream unreleased patch for gcc14 error
    (fetchpatch {
      name = "fix-incompatible-pointer-types.patch";
      url = "https://github.com/TelepathyIM/telepathy-glib/commit/72412c944b771f3214ddc40fa9dea82cea3a5651.patch";
      hash = "sha256-NXQel0eS7zK6FRbJcPsPXCQxos0xT8EN102vX94M5Vo=";
    })
  ];

  meta = with lib; {
    homepage = "https://telepathy.freedesktop.org";
    platforms = platforms.unix;
    license = with licenses; [
      bsd2
      bsd3
      lgpl21Plus
    ];
  };
}
