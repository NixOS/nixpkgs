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
  version = "9.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rc4mg+Px+0p2r38wxIah/rHqWjHSU0+KCPgqj/Gl3oo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libbladeRF
    libusb1
    ncurses
    rtl-sdr
    hackrf
  ] ++ lib.optional stdenv.isLinux limesuite;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-implicit-function-declaration -Wno-int-conversion -Wno-unknown-warning-option";

  buildFlags = [ "DUMP1090_VERSION=${version}" "dump1090" "view1090" ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 $out/bin
    cp -vr public_html $out/share/dump1090

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple Mode S decoder for RTLSDR devices";
    homepage = "https://github.com/flightaware/dump1090";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ earldouglas ];
  };
}
