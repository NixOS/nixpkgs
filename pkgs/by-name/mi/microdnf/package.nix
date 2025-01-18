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
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
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
    libsmartcols
    zchunk
    pcre2.dev
  ];

  meta = with lib; {
    description = "Lightweight implementation of dnf in C";
    homepage = "https://github.com/rpm-software-management/microdnf";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rb2k ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "microdnf";
  };
}
