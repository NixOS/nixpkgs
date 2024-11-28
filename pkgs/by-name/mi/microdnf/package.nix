{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  libdnf,
  pkg-config,
  glib,
  libpeas,
  libsmartcols,
  help2man,
  zchunk,
  pcre2,
}:

stdenv.mkDerivation rec {
  pname = "microdnf";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
    hash = "sha256-R7jOeH6pw/THLXxLezp2AmE8lUBagKMRJ0XfXgdLi2E=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    help2man
  ];

  buildInputs = [
    libdnf
    glib
    libpeas
    libsmartcols
    zchunk
    pcre2.dev
  ];

  meta = {
    description = "Lightweight implementation of dnf in C";
    homepage = "https://github.com/rpm-software-management/microdnf";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rb2k ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "microdnf";
  };
}
