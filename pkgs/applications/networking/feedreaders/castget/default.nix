{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, ronn
, curl
, id3lib
, libxml2
, glibcLocales
}:

stdenv.mkDerivation rec {
  pname = "castget";
  version = "2.0.1";

  src = fetchurl {
    url = "http://savannah.nongnu.org/download/castget/castget-${version}.tar.bz2";
    hash = "sha256-Q4tffsfjGkXtN1ZjD+RH9CAVrNpT7AkgL0hihya16HU=";
  };

  # without this, the build fails because of an encoding issue with the manual page.
  # https://stackoverflow.com/a/17031697/4935114
  # This requires glibcLocales to be present in the build so it will have an impact.
  # See https://github.com/NixOS/nixpkgs/issues/8398
  preBuild = ''
    export LC_ALL="en_US.UTF-8";
  '';

  buildInputs = [
    glib
    curl
    id3lib
    libxml2
  ];
  nativeBuildInputs = [
    ronn
    # See comment on locale above
    glibcLocales
    pkg-config
  ];

  meta = with lib; {
    description = "A simple, command-line based RSS enclosure downloader";
    longDescription = ''
      castget is a simple, command-line based RSS enclosure downloader. It is
      primarily intended for automatic, unattended downloading of podcasts.
    '';
    homepage = "https://castget.johndal.com/";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
