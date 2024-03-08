{ stdenv
, lib
, fetchFromGitHub
, cmake
, cmocka
, libdict
, ncurses
, jansson
, openssl
, libpcap
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bngblaster";
  version = "0.8.39";

  src = fetchFromGitHub {
    owner = "rtbrick";
    repo = "bngblaster";
    rev = finalAttrs.version;
    hash = "sha256-w8E/GcwLCH6OYwabRWH+CNQ2p7scMK8ogReRxNFqI4k=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libdict
    ncurses
    jansson
    openssl
    cmocka
  ] ++ lib.optionals finalAttrs.doCheck [
    libpcap
  ];

  cmakeFlags = [
    "-DBNGBLASTER_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
    "-DBNGBLASTER_VERSION=${finalAttrs.version}"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/rtbrick/bngblaster/";
    changelog = "https://github.com/rtbrick/bngblaster/releases/tag/${finalAttrs.version}";
    description = "network tester for access and routing protocols";
    license = licenses.bsd3;
    maintainers = teams.wdz.members;
    badPlatforms = platforms.darwin;
  };
})
