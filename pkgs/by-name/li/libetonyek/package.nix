{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, boost
, cppunit
, glm
, gperf
, liblangtag
, librevenge
, libxml2
, mdds
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libetonyek";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "LibreOffice";
    repo = "libetonyek";
    rev = "libetonyek-${version}";
    hash = "sha256-dvYbV+7IakgOkGsZ+zaW+qgn/QoD6Jwq/juaE+7iYug=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost
    cppunit
    glm
    gperf
    liblangtag
    librevenge
    libxml2
    mdds
    zlib
  ];

  configureFlags = ["--with-mdds=2.1"];

  meta = with lib; {
    description = "Library and a set of tools for reading and converting Apple iWork documents (Keynote, Pages and Numbers)";
    homepage = "https://github.com/LibreOffice/libetonyek";
    changelog = "https://github.com/LibreOffice/libetonyek/blob/${src.rev}/NEWS";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
