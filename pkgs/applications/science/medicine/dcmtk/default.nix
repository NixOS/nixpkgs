{ lib, stdenv, fetchFromGitHub, zlib, libtiff, libxml2, openssl, libiconv, libpng, cmake }:

with lib;
stdenv.mkDerivation rec {
  pname = "dcmtk";
  version = "3.6.6";
  src = fetchFromGitHub {
    owner = "DCMTK";
    repo = pname;
    rev = "DCMTK-${version}";
    sha256 = "sha256-bpvf2JJXikV/CqmXZb3w4Ua3VBEQcQk7PXw9ie0t8xo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpng zlib libtiff libxml2 openssl libiconv ];

  meta = {
    description = "Collection of libraries and applications implementing large parts of the DICOM standard";
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
    platforms = platforms.linux;
  };
}
