{ lib, stdenv
, fetchFromGitHub
, pkg-config
, curl
, glib
, jansson
, ncurses
, protobuf
, protobufc
, hackrf
, libbladeRF
, libusb1
, rtl-sdr
, limesuite
, DarwinTools
}:

stdenv.mkDerivation rec {
  pname = "rbfeeder";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "airnavsystems";
    repo = pname;
    rev = "17a5f65da1b9ca1a01c636eb728ea6db9010b708";
    sha256 = "sha256-kvgS9d9nCnsuY21WvJyW/GmgPZsU8tuySNaBLP7yQZs=";
  };

  nativeBuildInputs = [ pkg-config protobufc ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [
    curl
    glib
    jansson
    ncurses
    protobuf
    hackrf
    libbladeRF
    libusb1
    rtl-sdr
  ] ++ lib.optional stdenv.isLinux limesuite;

  doCheck = true;

  # make wildcard expansion doesn't seem to notice the
  # 'rbfeeder.pb-c.c' file generated in 'proto'
  # so we need to use two make runs
  preBuild = ''
    make proto
  '';

  buildFlags = [ "rbfeeder" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -v rbfeeder $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "ADS-B client software used by AirNav to decode Mode S messages and send to their processing servers";
    homepage = "https://github.com/airnavsystems/rbfeeder";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ snicket2100 ];
  };
}
