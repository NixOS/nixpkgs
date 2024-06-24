{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, glib
, boost
, libsigrok
, libserialport
, libzip
, libftdi1
, hidapi
, glibmm
, python3
, bluez
, pcre
, libsForQt5
, desktopToDarwinBundle
, qt5
}:

stdenv.mkDerivation rec {
  pname = "smuview";
  version = "0.0.5-unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "knarfS";
    repo = "smuview";
    rev = "a5ffb66287b725ebcdecc1eab04a4574c8585f66";
    hash = "sha256-WH8X75yk0aMivbBBOyODcM1eBWwa5UO/3nTaKV1LCGs=";
  };

  nativeBuildInputs = [ cmake pkg-config qt5.wrapQtAppsHook ]
    ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    glib
    boost
    libsigrok
    libserialport
    libzip
    libftdi1
    hidapi
    glibmm
    python3
    pcre
    libsForQt5.qwt
  ] ++ lib.optionals stdenv.isLinux [ bluez ];

  meta = with lib; {
    description = "Qt based source measure unit GUI for sigrok";
    mainProgram = "smuview";
    longDescription = "SmuView is a GUI for sigrok that supports power supplies, electronic loads and all sorts of measurement devices like multimeters, LCR meters and so on";
    homepage = "https://github.com/knarfS/smuview";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vifino ];
    platforms = platforms.unix;
  };
}
