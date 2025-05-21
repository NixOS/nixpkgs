{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.major version}/gnome-backgrounds-${version}.tar.xz";
    hash = "sha256-LWuqAR7peATHVh9+HL2NR2PjC1W4gY3aePn3WvuNjQU=";
  };

  patches = [
    # Makes the database point to stable paths in /run/current-system/sw/share, which don't decay whenever this package's hash changes.
    # This assumes a nixos + gnome system, where this package is installed in environment.systemPackages,
    # and /share outputs are included in environment.pathsToLink.
    ./stable-dir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-backgrounds"; };
  };

  meta = with lib; {
    description = "Default wallpaper set for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-backgrounds";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-backgrounds/-/blob/${version}/NEWS?ref_type=tags";
    license = licenses.cc-by-sa-30;
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
}
