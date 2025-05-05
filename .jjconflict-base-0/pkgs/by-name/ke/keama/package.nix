{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "keama";
  version = "4.4.3-P1";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/dhcp/${version}/dhcp-${version}.tar.gz";
    sha256 = "sha256-CsQWu1WZfKhjIXT9EHN/1hzbjbonUhYKM1d1vCHcc8c=";
  };

  enableParallelBuilding = true;

  # The Kea Migration Assistant lives as a subdirectory of the
  # original ISC DHCP server source code.
  makeFlags = [
    "-C"
    "keama"
  ];

  meta = with lib; {
    description = "Kea Migration Assistent";

    longDescription = ''
      Kea migration assistant is an experimental tool that reads a ISC DHCP server
      configuration and produces a JSON configuration in Kea format.
    '';

    homepage = "https://gitlab.isc.org/isc-projects/dhcp/-/wikis/kea-migration-assistant";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ blitz ];
    mainProgram = "keama";
  };
}
