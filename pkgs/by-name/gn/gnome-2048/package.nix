{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  wrapGAppsHook3,
  meson,
  vala,
  pkg-config,
  ninja,
  itstool,
  clutter-gtk,
  libgee,
  libgnome-games-support,
  gnome,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-twenty-forty-eight";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-2048/${lib.versions.majorMinor finalAttrs.version}/gnome-2048-${finalAttrs.version}.tar.xz";
    hash = "sha256-4nNn9cCaATZYHTNfV5E6r1pfGA4ymcxcGjDYWD55rmg=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.gnome.org/GNOME/gnome-2048/-/merge_requests/21
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-2048/-/commit/194e22699f7166a016cd39ba26dd719aeecfc868.patch";
      hash = "sha256-Qpn/OJJwblRm5Pi453aU2HwbrNjsf+ftmSnns/5qZ9E=";
    })
  ];

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    clutter-gtk
    libgee
    libgnome-games-support
    gtk3
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-2048";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-2048";
    description = "Obtain the 2048 tile";
    mainProgram = "gnome-2048";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
