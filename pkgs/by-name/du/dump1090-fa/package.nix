{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "11.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A6nkct7jvpPtPZ+iM2UKVckIXgNxxq5sxhyPiw5+EZk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    hackrf
    libbladeRF
    libusb1
    ncurses
    rtl-sdr
    soapysdr-with-plugins
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux limesuite;

  buildFlags = [
    "DUMP1090_VERSION=${finalAttrs.version}"
    "showconfig"
    "dump1090"
    "view1090"
    "faup1090"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 faup1090 $out/bin
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
      ryand56
    ];
    mainProgram = "dump1090";
  };
})
