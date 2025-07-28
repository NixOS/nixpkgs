{
  stdenv,
  lib,
  fetchFromGitLab,
}:

stdenv.mkDerivation rec {
  pname = "hostname-debian";
  version = "3.25";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "meskes";
    repo = "hostname";
    tag = "debian/${version}";
    hash = "sha256-Yq8P5bF/RRZnWuFW0y2u08oZrydAKfopOtbrwbeIu3w=";
  };

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = with lib; {
    changelog = "https://salsa.debian.org/meskes/hostname/-/blob/${src.tag}/debian/changelog";
    description = "Utility to set/show the host name or domain name";
    longDescription = ''
      This package provides commands which can be used to display the system's
      DNS name, and to display or set its hostname or NIS domain name.
    '';
    homepage = "https://tracker.debian.org/pkg/hostname";
    license = licenses.gpl2Plus;
    mainProgram = "hostname";
    maintainers = with maintainers; [ posch ];
    platforms = platforms.gnu;
  };
}
