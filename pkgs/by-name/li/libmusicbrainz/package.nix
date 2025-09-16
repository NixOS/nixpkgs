{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  neon,
  libdiscid,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "libmusicbrainz";
  version = "5.1.0-unstable-2025-07-12";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "libmusicbrainz";
    rev = "4efbed3afae11ef68281816088d7cf3d0f704dfe";
    hash = "sha256-2nMm+vm/uOT7AzTQIvfpmBsNYApZF0mekDEgt7tC6fw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    neon
    libdiscid
    libxml2
  ];

  meta = {
    homepage = "http://musicbrainz.org/doc/libmusicbrainz";
    description = "MusicBrainz Client Library";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.
    '';
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl21Plus;
  };
}
