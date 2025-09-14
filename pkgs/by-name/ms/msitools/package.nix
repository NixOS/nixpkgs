{
  lib,
  stdenv,
  fetchurl,
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
    maintainers = with lib.maintainers; [ PlushBeaver ];
    platforms = lib.platforms.unix;
  };
}
