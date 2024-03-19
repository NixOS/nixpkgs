{ lib, stdenv, fetchgit, pkg-config, cmake, glib, boost, libsigrok
, libsigrokdecode, libserialport, libzip, libftdi1, hidapi, glibmm
, pcre, python3, qtsvg, qttools, bluez
, wrapQtAppsHook, desktopToDarwinBundle
}:

stdenv.mkDerivation rec {
  pname = "pulseview";
  version = "0.4.2-unstable-2024-01-26";

  src = fetchgit {
    url = "git://sigrok.org/pulseview";
    rev = "9b8b7342725491d626609017292fa9259f7d5e0e";
    hash = "sha256-UEJunADzc1WRRfchO/n8qqxnyrSo4id1p7gLkD3CKaM=";
  };

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ]
    ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    glib boost libsigrok libsigrokdecode libserialport libzip libftdi1 hidapi glibmm
    pcre python3
    qtsvg
  ] ++ lib.optionals stdenv.isLinux [ bluez ];

  meta = with lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    mainProgram = "pulseview";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor vifino ];
    platforms = platforms.unix;
  };
}
