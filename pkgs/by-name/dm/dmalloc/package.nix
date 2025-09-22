{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  dmalloc,
}:

stdenv.mkDerivation rec {
  pname = "dmalloc";
  version = "5.6.5";

  src = fetchFromGitHub {
    owner = "j256";
    repo = "dmalloc";
    rev = "dmalloc_release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-P63I9s32C3v1q+Sy9joK0HKYb0ebBu9g72tTTwxvkz8=";
  };

  configureFlags = [
    "--enable-cxx"
    "--enable-shlib"
    "--enable-threads"
  ];

  passthru.tests.version = testers.testVersion {
    package = dmalloc;
  };

  meta = with lib; {
    description = "Debug Malloc memory allocation debugging C library";
    longDescription = ''
      The debug memory allocation or "dmalloc" library has been designed as a
      drop in replacement for the system's malloc, realloc, calloc, free and
      other memory management routines while providing powerful debugging
      facilities configurable at runtime. These facilities include such things
      as memory-leak tracking, fence-post write detection, file/line number
      reporting, and general logging of statistics.
    '';
    homepage = "https://dmalloc.com";
    license = licenses.isc;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
    mainProgram = "dmalloc";
  };
}
