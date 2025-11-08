{
  lib,
  stdenv,
  cmake,
  cmocka,
  fetchFromGitHub,
  jansson,
  libdict,
  libpcap,
  ncurses,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bngblaster";
  version = "0.9.26";

  src = fetchFromGitHub {
    owner = "rtbrick";
    repo = "bngblaster";
    rev = finalAttrs.version;
    hash = "sha256-EZc+cageuhPSIwyHAW6JTbSGQwlHCl9YpUHzHZ0ygx0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libdict
    ncurses
    jansson
    openssl
    cmocka
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [ libpcap ];

  cmakeFlags = [
    "-DBNGBLASTER_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DBNGBLASTER_VERSION=${finalAttrs.version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Network tester for access and routing protocols";
    homepage = "https://github.com/rtbrick/bngblaster/";
    changelog = "https://github.com/rtbrick/bngblaster/releases/tag/${finalAttrs.version}";
    license = licenses.bsd3;
    teams = [ teams.wdz ];
    badPlatforms = platforms.darwin;
  };
})
