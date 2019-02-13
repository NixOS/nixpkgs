{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook,
  glib, gtk3, pcsclite, lua5_2, curl, readline }:
let
  version = "0.8.4";
in
  stdenv.mkDerivation {
    name = "cardpeek-${version}";

    src = fetchFromGitHub {
      owner = "L1L1";
      repo = "cardpeek";
      rev = "cardpeek-${version}";
      sha256 = "1ighpl7nvcvwnsd6r5h5n9p95kclwrq99hq7bry7s53yr57l6588";
    };

    nativeBuildInputs = [ pkgconfig autoreconfHook ];
    buildInputs = [ glib gtk3 pcsclite lua5_2 curl readline ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = https://github.com/L1L1/cardpeek;
      description = "A tool to read the contents of ISO7816 smart cards";
      license = licenses.gpl3Plus;
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [ embr ];
    };
  }
