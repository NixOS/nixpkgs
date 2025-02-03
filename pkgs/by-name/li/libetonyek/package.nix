{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
# fails on older Boost due to https://github.com/boostorg/phoenix/issues/111
, boost184
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
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "LibreOffice";
    repo = "libetonyek";
    rev = "libetonyek-${version}";
    hash = "sha256-wgyeQj1sY78sbbZT+NZuq9HEKB+ta7wwipbfN3JkyyU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost184
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
