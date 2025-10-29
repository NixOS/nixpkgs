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
  util-linux,
  help2man,
  zchunk,
  pcre2,
}:

stdenv.mkDerivation rec {
  pname = "microdnf";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "microdnf";
    rev = version;
    hash = "sha256-xWHE05CeX8I8YO0gqf5FDiqLexirwKdyCe4grclOVYc=";
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
    util-linux
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
