{ lib, mkDerivation, fetchFromGitHub, pkg-config, cmake
, libzip, boost, fftw, qtbase, libusb1, libsigrok4dsl
, libsigrokdecode4dsl, python3, fetchpatch
}:

mkDerivation rec {
  pname = "dsview";

  version = "1.12";

  src = fetchFromGitHub {
      owner = "DreamSourceLab";
      repo = "DSView";
      rev = "v${version}";
      sha256 = "q7F4FuK/moKkouXTNPZDVon/W/ZmgtNHJka4MiTxA0U=";
  };

  sourceRoot = "source/DSView";

  patches = [
    # Fix absolute install paths
    ./install.patch

    # Fix buld with Qt5.15 already merged upstream for future release
    # Using local file instead of content of commit #33e3d896a47 because
    # sourceRoot make it unappliable
    ./qt515.patch

    # Change from upstream master that removes extern-C scopes which
    # cause failures with modern glib. This can likely be removed if
    # there is an upstream release >1.12
    (fetchpatch {
      name = "fix-extern-c.patch";
      url = "https://github.com/DreamSourceLab/DSView/commit/33cc733abe19872bf5ed08540a94b798d0d4ecf4.patch";
      sha256 = "sha256-TLfLQa3sdyNHTpMMvId/V6uUuOFihOZMFJOj9frnDoY=";
      stripLen = 2;
      extraPrefix = "";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost fftw qtbase libusb1 libzip libsigrokdecode4dsl libsigrok4dsl
    python3
  ];

  meta = with lib; {
    description = "A GUI program for supporting various instruments from DreamSourceLab, including logic analyzer, oscilloscope, etc";
    homepage = "https://www.dreamsourcelab.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bachp ];
  };
}
