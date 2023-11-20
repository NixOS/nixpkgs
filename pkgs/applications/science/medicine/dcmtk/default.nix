{ lib, stdenv, fetchFromGitHub, zlib, libtiff, libxml2, openssl, libiconv
, libpng, cmake, fetchpatch }:

with lib;
stdenv.mkDerivation rec {
  pname = "dcmtk";
  version = "3.6.7";
  src = fetchFromGitHub {
    owner = "DCMTK";
    repo = pname;
    rev = "DCMTK-${version}";
    sha256 = "sha256-Pw99R6oGcLX6Z7s8ZnpbBBqcIvY9Rl/nw2PVGjpD3gY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpng zlib libtiff libxml2 openssl libiconv ];

  # This is only needed until https://github.com/DCMTK/dcmtk/pull/75/files is merged
  patches = [ ./0001-Fix-cmake.patch ];

  doCheck = true;

  meta = {
    description =
      "Collection of libraries and applications implementing large parts of the DICOM standard";
    longDescription = ''
      DCMTK is a collection of libraries and applications implementing large parts of the DICOM standard.
      It includes software for examining, constructing and converting DICOM image files, handling offline media,
      sending and receiving images over a network connection, as well as demonstrative image storage and worklist servers.
      DCMTK is is written in a mixture of ANSI C and C++.
      It comes in complete source code and is made available as "open source" software.
    '';
    homepage = "https://dicom.offis.de/dcmtk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ iimog ];
    platforms = with platforms; linux ++ darwin;
  };
}
