{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
}:
stdenv.mkDerivation {
  pname = "ch341eeprom";
  version = "0-unstable-2021-01-05";

  src = fetchFromGitHub {
    owner = "command-tab";
    repo = "ch341eeprom";
    rev = "d5b2fba35a33a1cddd7a3e920e1df933f21ba9b0";
    hash = "sha256-QUl5ErOfEfDhk1fF+BNu6n0Bake3IagNfn4I43b6Uns=";
  };

  buildInputs = [ libusb1 ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 -T ch341eeprom $out/bin/ch341eeprom
    runHook postInstall
  '';

  meta = with lib; {
    description = "A libusb based programming tool for 24Cxx serial EEPROMs using the WinChipHead CH341A IC";
    homepage = "https://github.com/command-tab/ch341eeprom";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    mainProgram = "ch341eeprom";
    maintainers = with maintainers; [ xokdvium ];
  };
}
