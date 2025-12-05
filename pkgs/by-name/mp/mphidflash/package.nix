{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb-compat-0_1,
}:

stdenv.mkDerivation {
  pname = "mphidflash";
  version = "1.8-unstable-2020-05-05";

  src = fetchFromGitHub {
    owner = "AdamLaurie";
    repo = "mphidflash";
    rev = "d65bedd3f564a5d91b29e06b4a5885c32780acc5";
    hash = "sha256-akQjkkbGxkurBifTZuI+iVs8O2i8MM0LgMUYztg5hzE=";
  };

  nativeBuildInputs = [ libusb-compat-0_1 ];

  buildFlags = [ "mphidflash64" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp binaries/mphidflash-1.8-linux-64 $out/bin/mphidflash

    runHook postInstall
  '';

  meta = {
    description = "Command-line tool for communicating with Microchips USB HID-Bootloader and downloading new firmware";
    homepage = "https://github.com/AdamLaurie/mphidflash";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jaschutte ];
    platforms = lib.platforms.linux;
    mainProgram = "mphidflash";
  };
}
