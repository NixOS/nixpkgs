{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  python3,
  gettext,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "cantarell-fonts";
  version = "0.311";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "cantarell-fonts";
    tag = version;
    hash = "sha256-FR53OZxJ7WRUDqMB2GriQ3UOxozWwbFiz3/9VaUWYrc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3.pkgs.afdko # for otfautohint
    python3.pkgs.cffsubr
    python3.pkgs.ufo2ft
    python3.pkgs.uharfbuzz
    gettext
  ];

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    changelog = "https://gitlab.gnome.org/GNOME/cantarell-fonts/-/blob/${src.tag}/NEWS";
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    homepage = "https://cantarell.gnome.org/";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
    maintainers = [ ];
  };
}
