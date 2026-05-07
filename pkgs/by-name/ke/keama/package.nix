{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keama";
  version = "4.4.3-P1";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/dhcp/${finalAttrs.version}/dhcp-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-CsQWu1WZfKhjIXT9EHN/1hzbjbonUhYKM1d1vCHcc8c=";
  };

  enableParallelBuilding = true;

  # The Kea Migration Assistant lives as a subdirectory of the
  # original ISC DHCP server source code.
  makeFlags = [
    "-C"
    "keama"
  ];

  meta = {
    description = "Kea Migration Assistent";

    longDescription = ''
      Kea migration assistant is an experimental tool that reads a ISC DHCP server
      configuration and produces a JSON configuration in Kea format.
    '';

    homepage = "https://gitlab.isc.org/isc-projects/dhcp/-/wikis/kea-migration-assistant";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ blitz ];
    mainProgram = "keama";
  };
})
