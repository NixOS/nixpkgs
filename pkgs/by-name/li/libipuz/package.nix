{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
}:

stdenv.mkDerivation rec {
  pname = "libipuz";
  version = "0.4.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "libipuz";
    rev = version;
    hash = "sha256-psC2cFqSTlToCtCxwosXyJbmX/96AEI0xqzXtlc/HQE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ];

  buildInputs = [
    glib
    json-glib
  ];

  meta = {
    description = "Library for parsing .ipuz puzzle files";
    homepage = "https://gitlab.gnome.org/jrb/libipuz";
    changelog = "https://gitlab.gnome.org/jrb/libipuz/-/blob/${version}/NEWS.md?ref_type=tags";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
