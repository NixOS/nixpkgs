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
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "rtbrick";
    repo = "bngblaster";
    rev = finalAttrs.version;
    hash = "sha256-HqwyqUkLYoXTjx01pB8sL3hBXwLqe441M+LTqBhaZ58=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libdict
    ncurses
    jansson
    openssl
    cmocka
  ] ++ lib.optionals finalAttrs.finalPackage.doCheck [ libpcap ];

  cmakeFlags = [
    (lib.cmakeBool "BNGBLASTER_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "BNGBLASTER_VERSION" finalAttrs.version)
  ];

  doCheck = true;

  meta = with lib; {
    description = "Network tester for access and routing protocols";
    homepage = "https://github.com/rtbrick/bngblaster/";
    changelog = "https://github.com/rtbrick/bngblaster/releases/tag/${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = teams.wdz.members;
    badPlatforms = platforms.darwin;
  };
})
