{ lib, stdenv, fetchurl, fetchpatch, pkg-config, cmake, glib, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi1, glibmm
, pcre, python3, qtsvg, qttools, wrapQtAppsHook, desktopToDarwinBundle
}:

stdenv.mkDerivation rec {
  pname = "pulseview";
  version = "0.4.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/pulseview/pulseview-${version}.tar.gz";
    hash = "sha256-8EL3ej4bNb8wZmMw427Dj6uNJIw2k8N7fjXUAcO/q8s=";
  };

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ]
    ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    glib boost libsigrok libsigrokdecode libserialport libzip libusb1 libftdi1 glibmm
    pcre python3
    qtsvg
  ] ++ lib.optional stdenv.isLinux udev;

  patches = [
    # Allow building with glib 2.68
    # PR at https://github.com/sigrokproject/pulseview/pull/39
    (fetchpatch {
      url = "https://github.com/sigrokproject/pulseview/commit/fb89dd11f2a4a08b73c498869789e38677181a8d.patch";
      hash = "sha256-0PlE/z4tbN1JFfAUBeZiXc3ENzwuhCaulIBRmXTULh4=";
    })
    # Fixes replaced/obsolete Qt methods
    (fetchpatch {
      url = "https://github.com/sigrokproject/pulseview/commit/ae726b70a7ada9a4be5808e00f0c951318479684.patch";
      hash = "sha256-6bFXFAnTO+MBUmslw55gWWSCCPwnejqKGpHeJOoH0e8=";
    })
  ];

  meta = with lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
