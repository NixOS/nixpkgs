{
  fetchFromGitHub,
  bubblewrap,
  fontconfig,
  gdk-pixbuf,
  gettext,
  gobject-introspection,
  gtk3,
  isocodes,
  libseccomp,
  meson,
  ninja,
  pkg-config,
  pulseaudio,
  python3,
  lib,
  replaceVars,
  stdenv,
  systemdLibs,
  xkeyboard_config,
  libxrandr,
  libxext,
  libxkbfile,
  wrapGAppsHook3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cinnamon-desktop";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-desktop";
    tag = finalAttrs.version;
    hash = "sha256-E8mvVfdilMV0J01C8oUqRKuAx8mjHrMNMXSEioeCoRw=";
  };

  patches = [
    (replaceVars ./bubblewrap-paths.patch {
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    pulseaudio
  ];

  buildInputs = [
    bubblewrap
    fontconfig
    gdk-pixbuf
    isocodes
    systemdLibs
    xkeyboard_config
    libseccomp
    libxkbfile
    libxext
    libxrandr
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
    wrapGAppsHook3
    gettext
    pkg-config
    gobject-introspection
  ];

  postPatch = ''
    chmod +x install-scripts/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs install-scripts/meson_install_schemas.py
    sed "s|/usr/share|/run/current-system/sw/share|g" -i ./schemas/* # NOTE: unless this causes a circular dependency, we could link it to cinnamon/share/cinnamon
  '';

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-desktop";
    description = "Library and data for various Cinnamon modules";

    longDescription = ''
      The libcinnamon-desktop library provides API shared by several applications
      on the desktop, but that cannot live in the platform for various
      reasons. There is no API or ABI guarantee, although we are doing our
      best to provide stability. Documentation for the API is available with
      gtk-doc.
    '';

    license = [
      lib.licenses.gpl2
      lib.licenses.lgpl2
    ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
