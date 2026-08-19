{
  stdenv,
  lib,
  fetchurl,
  pam,
  coreutils,
}:
stdenv.mkDerivation rec {
  pname = "pam_xdg";
  version = "0.8.5";

  src = fetchurl {
    url = "https://ftp.sdaoden.eu/pam_xdg-${version}.tar.gz";
    sha256 = "sha256-o4Fol6LouBQVLiGMAszEB+zBkBj8C1xMp057AvH3nl4=";
  };

  buildInputs = [
    pam
  ];

  postPatch = ''
    substituteInPlace pam_xdg.c \
      --replace-fail '"/usr/bin/rm"' '"${coreutils}/bin/rm"'
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://www.sdaoden.eu/code-pam_xdg.html";
    description = "PAM module that manages XDG Base Directories";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib; [ maintainers.aanderse ];
  };
}
