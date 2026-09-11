{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  meson,
  ninja,
  vala,
  gobject-introspection,
  perl,
  bison,
  gettext,
  glib,
  pkg-config,
  libgsf,
  gcab,
  bzip2,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "msitools";
  version = "0.106";

  src = fetchurl {
    url = "mirror://gnome/sources/msitools/${lib.versions.majorMinor version}/msitools-${version}.tar.xz";
    hash = "sha256-HtNCec+AgPFPG48Q5klHQSVJKgiZEufKcOWd+i5aZZs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    gobject-introspection
    perl
    bison
    gettext
    pkg-config
  ];

  buildInputs = [
    glib
    libgsf
    gcab
    bzip2
  ];

  patches = [
    # Cherry-picked from upstream to fix test failure. Drop for ver >= 0.106
    (fetchpatch2 {
      name = "libmsi-open-0-byte-streams-with-libgsf-1.14.59.patch";
      url = "https://gitlab.gnome.org/GNOME/msitools/-/commit/fc2daea77a1186a946304c930727223333266a1b.patch?full_index=1";
      hash = "sha256-SomD7V5pb8Ai9io7FLS7W3MnqsRxMsPwLlNVBwmgerY=";
    })
  ];

  # WiX tests fail on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    patchShebangs subprojects/bats-core/{bin,libexec}
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = "https://gitlab.gnome.org/GNOME/msitools";
    license = with lib.licenses; [
      # Library
      lgpl21Plus
      # Tools
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      kanru
      PlushBeaver
    ];
    platforms = lib.platforms.unix;
  };
}
