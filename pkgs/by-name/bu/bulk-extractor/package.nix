{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook

, exiv2
, flex
, git
, libewf
, libgcrypt
, libgpg-error
, libpcap
, libuuid
, libxml2
, ncurses
, openssl
, sqlite
, termcap
, tre
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bulk_extractor";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = "bulk_extractor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LNdRN4pEA0rVEyKiBKGJgTKA4veVvsuP3ufiolHTk/s=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    exiv2
    flex
    git
    libewf
    libgcrypt
    libgpg-error
    libpcap
    libuuid
    libxml2
    ncurses
    openssl
    sqlite
    termcap
    tre
    zlib
  ];

  inherit (import ./common.nix { inherit lib finalAttrs; }) meta;
})
