{ lib, stdenv
, fetchFromGitHub
, pkg-config
, libbladeRF
, libusb1
, ncurses
, rtl-sdr
, hackrf
, limesuite
}:

stdenv.mkDerivation rec {
  pname = "dump1090";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1fD8ZMkTS/r+p1rrOfJhH2sz3sJCapQcvk8f8crGApw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libbladeRF
    libusb1
    ncurses
    rtl-sdr
    hackrf
  ] ++ lib.optional stdenv.isLinux limesuite;

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-implicit-function-declaration -Wno-int-conversion";

  buildFlags = [ "dump1090" "view1090" ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 $out/bin
    cp -vr public_html $out/share/dump1090

    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A simple Mode S decoder for RTLSDR devices";
    homepage = "https://github.com/flightaware/dump1090";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ earldouglas ];
  };
}
