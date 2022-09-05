{ mkDerivation, lib, fetchurl, fetchpatch, pkg-config, cmake, glib, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi1, glibmm
, pcre, librevisa, python3, qtbase, qtsvg, qttools
}:

mkDerivation rec {
  pname = "pulseview";
  version = "0.4.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/pulseview/${pname}-${version}.tar.gz";
    sha256 = "1jxbpz1h3m1mgrxw74rnihj8vawgqdpf6c33cqqbyd8v7rxgfhph";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    glib boost libsigrok libsigrokdecode libserialport libzip udev libusb1 libftdi1 glibmm
    pcre librevisa python3
    qtbase qtsvg qttools
  ];

  patches = [
    # Allow building with glib 2.68
    # PR at https://github.com/sigrokproject/pulseview/pull/39
    (fetchpatch {
      url = "https://github.com/sigrokproject/pulseview/commit/fb89dd11f2a4a08b73c498869789e38677181a8d.patch";
      sha256 = "07ifsis9jlc0jjp2d11f7hvw9kaxcbk0a57h2m4xsv1d7vzl9yfh";
    })
  ];

  meta = with lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
