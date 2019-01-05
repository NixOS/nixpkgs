{ stdenv, fetchFromGitHub, pkgconfig, cmake, autoreconfHook,
glib, libzip, boost, fftw, qtbase,
libusb, makeWrapper, libsigrok4dsl, libsigrokdecode4dsl
}:

stdenv.mkDerivation rec {
  name = "dsview-${version}";

  version = "0.99";

  src = fetchFromGitHub {
      owner = "DreamSourceLab";
      repo = "DSView";
      rev = version;
      sha256 = "189i3baqgn8k3aypalayss0g489xi0an9hmvyggvxmgg1cvcwka2";
  };

  postUnpack = ''
    export sourceRoot=$sourceRoot/DSView
  '';

  patches = [
    # Fix absolute install paths
    ./install.patch
  ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [
   boost fftw qtbase libusb libzip libsigrokdecode4dsl libsigrok4dsl
  ];

  enableParallelBuilding = true;

  postFixup = ''
    wrapProgram $out/bin/DSView --suffix QT_PLUGIN_PATH : \
      ${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  meta = with stdenv.lib; {
    description = "A GUI program for supporting various instruments from DreamSourceLab, including logic analyzer, oscilloscope, etc";
    homepage = http://www.dreamsourcelab.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bachp ];
  };
}
