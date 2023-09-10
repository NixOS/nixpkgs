{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, bison
, libevent
, libressl
, ncurses
, autoreconfHook
, buildPackages
, memstreamHook
}:

stdenv.mkDerivation rec {
  pname = "telescope";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    sha256 = "sha256-9gZeBAC7AGU5vb+692npjKbbqFEAr9iGLu1u68EJ0W8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
  ];

  buildInputs = [
    libevent
    libressl
    ncurses
  ] ++ lib.optional stdenv.isDarwin memstreamHook;

  configureFlags = [
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    description = "Telescope is a w3m-like browser for Gemini";
    homepage = "https://telescope.omarpolo.com/";
    license = licenses.isc;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.unix;
  };
}
