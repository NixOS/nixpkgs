{ lib, stdenv, fetchFromGitHub, opensp, pkg-config, libxml2, curl
, autoconf, automake, libtool, gengetopt, libiconv }:

stdenv.mkDerivation rec {
  pname = "libofx";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "LibOFX";
    repo = pname;
    rev = version;
    sha256 = "sha256-KOQrEAt1jHrOpPQ7QbGUADe0i7sQXNH2fblPRzT0EIg=";
  };

  preConfigure = "./autogen.sh";
  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  nativeBuildInputs = [ pkg-config libtool autoconf automake gengetopt ];
  buildInputs = [ opensp libxml2 curl ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = {
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = "https://libofx.sourceforge.net/";
    license = "LGPL";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
