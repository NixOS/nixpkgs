{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  glib,
  gtk3,
  freerdp3,
  fuse3,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gtk-frdp";
  version = "0-unstable-2024-07-03";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "6cfdc840159bb349310c3b81cd2df949f1522760";
    sha256 = "Fth2kaZEy5pOvaHu10Mr/6awWuAeyQ1T9JbNL9Sl8fU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    freerdp3
    fuse3
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
      hardcodeZeroVersion = true;
    };
  };

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-DTARGET_OS_IPHONE=0"
      "-DTARGET_OS_WATCH=0"
    ]
  );

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    maintainers = teams.gnome.members;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
