{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  hackrf,
  libbladeRF,
  libusb1,
  limesuite,
  ncurses,
  rtl-sdr,
  soapysdr-with-plugins,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dump1090";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    tag = "v${finalAttrs.version}";
    hash = "sha256-un2AK5RNkdQSWNbgbrn5K4eZXQdDOgUEzkcoLUVZ+sY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    hackrf
    libbladeRF
    libusb1
    ncurses
    rtl-sdr
    soapysdr-with-plugins
  ] ++ lib.optional stdenv.hostPlatform.isLinux limesuite;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-implicit-function-declaration -Wno-int-conversion -Wno-unknown-warning-option";

  buildFlags = [
    "DUMP1090_VERSION=${finalAttrs.version}"
    "showconfig"
    "dump1090"
    "view1090"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 $out/bin
    cp -vr public_html $out/share/dump1090

    runHook postInstall
  '';

  meta = {
    description = "Simple Mode S decoder for RTLSDR devices";
    homepage = "https://github.com/flightaware/dump1090";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      earldouglas
      aciceri
    ];
    mainProgram = "dump1090";
  };
})
