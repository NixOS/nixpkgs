{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation {
  pname = "pidof";
  version = "unstable-2005-01-25";
  src = fetchzip {
    url = "http://www.nightproductions.net/downloads/pidof_source.tar.gz";
    hash = "sha256-DsZrmBMUgnAkiteMgsYrPEJu78RueK4J8q0UX4aBNEs=";
  };

  makeFlags = [ "CC=cc" ];

  # Makefile tries to change the owner :/
  installPhase = ''
    runHook preInstall
    install pidof -Dt $out/bin/
    install pidof.1 -Dt $out/share/man/man1/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A utility to display the PID number for a given process name";
    platforms = with platforms; darwin;
    # Manpage says "This is free software", so I guess that's what it is?
    license = with licenses; [ free ];
    maintainers = with maintainers; [ atemu ];
  };
}
