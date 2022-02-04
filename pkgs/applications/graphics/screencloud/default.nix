{ lib, stdenv, fetchFromGitHub, cmake, qt4, quazip, qt-mobility, qxt, python2Packages }:

with lib;
stdenv.mkDerivation rec {
  pname = "screencloud";
  version = "1.2.0";

  # API Keys. According to the author of the AUR package, these are only used
  # for tracking usage.
  consumerKey = "23e747012c68601f27ab69c6de129ed70552d55b6";
  consumerSecret = "4701cb00c1bd357bbcae7c3d713dd216";

  src = fetchFromGitHub {
    owner = "olav-st";
    repo = "screencloud";
    rev = "v${version}";
    sha256 = "1s0dxa1sa37nvna5nfqdsp294810favj68qb7ghl78qna7zw0cim";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 quazip qt-mobility qxt python2Packages.python python2Packages.pycrypto ];

  patchPhase = ''
    # Required to make the configure script work. Normally, screencloud's
    # CMakeLists file sets the install prefix to /opt by force. This is stupid
    # and breaks nix, so we force it to install where we want. Please don't
    # write CMakeLists files like this, as things like this are why we can't
    # have nice things.
    substituteInPlace "CMakeLists.txt" --replace "set(CMAKE_INSTALL_PREFIX \"/opt\")" ""
  '';

  # We need to append /opt to our CMAKE_INSTALL_PREFIX, so we tell the Nix not
  # to add the argument for us.
  dontAddPrefix = true;

  cmakeFlags = [
    "-DQXT_QXTCORE_INCLUDE_DIR=${qxt}/include/QxtCore"
    "-DQXT_QXTCORE_LIB_RELEASE=${qxt}/lib/libQxtCore.so"
    "-DQXT_QXTGUI_INCLUDE_DIR=${qxt}/include/QxtGui"
    "-DQXT_QXTGUI_LIB_RELEASE=${qxt}/lib/libQxtGui.so"
    "-DCONSUMER_KEY_SCREENCLOUD=${consumerKey}"
    "-DCONSUMER_SECRET_SCREENCLOUD=${consumerSecret}"
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */screencloud)
  '';

  preConfigure = ''
    # This needs to be set in preConfigure instead of cmakeFlags in order to
    # access the $prefix environment variable.
    export cmakeFlags="-DCMAKE_INSTALL_PREFIX=$prefix/opt $cmakeFlags"
  '';

  # There are a number of issues with screencloud's installation. We need to add
  # pycrypto to the PYTHONPATH so that the SFTP plugin will work properly; and
  # we need to move the libPythonQt library into a folder where it can actually
  # be found.
  postInstall = ''
    patchShebangs $prefix/opt/screencloud/screencloud.sh
    substituteInPlace "$prefix/opt/screencloud/screencloud.sh" --replace "/opt" "$prefix/opt"
    sed -i "2 i\export PYTHONPATH=$(toPythonPath ${python2Packages.pycrypto}):\$PYTHONPATH" "$prefix/opt/screencloud/screencloud.sh"
    mkdir $prefix/bin
    mkdir $prefix/lib
    ln -s $prefix/opt/screencloud/screencloud.sh $prefix/bin/screencloud
    ln -s $prefix/opt/screencloud/libPythonQt.so $prefix/lib/libPythonQt.so
  '';

  meta = {
    homepage = "https://screencloud.net/";
    description = "Client for Screencloud, an easy to use screenshot sharing tool";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ forkk ];
    platforms = with lib.platforms; linux;
  };
}
