{ lib, stdenv, fetchFromGitHub, zlib, libtiff, libxml2, openssl, libiconv
, libpng, cmake }:

stdenv.mkDerivation rec {
  pname = "dcmtk";
  version = "3.6.8";
  src = fetchFromGitHub {
    owner = "DCMTK";
    repo = pname;
    rev = "DCMTK-${version}";
    hash = "sha256-PQR9+xSlfBvogv0p6AL/yapelJpsYteA4T4lPkOIfLc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpng zlib libtiff libxml2 openssl libiconv ];

  doCheck = true;

  meta = with lib; {
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
