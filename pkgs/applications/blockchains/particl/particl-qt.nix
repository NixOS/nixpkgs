{ stdenv, fetchFromGitHub, autoreconfHook, boost, db48, libevent, miniupnpc
, openssl, pkgconfig, zeromq, zlib, unixtools, python3, makeWrapper, qtbase
, qttools, qrencode, protobuf, libusb1, hidapi, wrapQtAppsHook, rapidcheck }:

let
  # Following "borrowed" from yubikey-manager-qt
  qmlPath = qmlLib: "${qmlLib}/${qtbase.qtQmlPrefix}";

  qml2ImportPath =
    stdenv.lib.concatMapStringsSep ":" qmlPath [ qtbase.bin qrencode ];

in with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "particl-qt";

  version = "0.18.1.4";

  src = fetchFromGitHub {
    owner = "particl";
    repo = "particl-core";
    rev = "v${version}";
    sha256 = "1vih5z0zr83g662am52xyk043x2ix2lvvj1a1szc5q2wapl7r0k9";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook wrapQtAppsHook ];

  buildInputs = [
    openssl
    db48
    boost
    zlib
    miniupnpc
    libevent
    zeromq
    unixtools.hexdump
    makeWrapper
    qtbase
    qttools
    qrencode
    protobuf
    libusb1
    hidapi
  ];

  configureFlags = [
    "--disable-bench"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-gui=qt5"
    "--enable-usbdevice=yes"
    "--with-qt-bindir=${qtbase}/bin:${qttools}/bin:${qtbase.dev}/bin:${qttools.dev}/bin"
  ] ++ optionals (!doCheck) [ "--disable-tests" "--disable-gui-tests" ];

  checkInputs = [ rapidcheck python3 ];

  # Always check during Hydra builds
  doCheck = true;

  # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
  # See also https://github.com/NixOS/nixpkgs/issues/24256
  checkFlags = [
    "LC_ALL=C.UTF-8"
    "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}"
  ];

  postInstall = ''
    wrapProgram $out/bin/particl-qt \
      --set QML2_IMPORT_PATH "${qml2ImportPath}" \
      --set QT_PLUGIN_PATH "${qtbase.bin}/${qtbase.qtPluginPrefix}"
  '';

  preCheck = "patchShebangs test";

  enableParallelBuilding = true;

  meta = {
    description =
      "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription = ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
    '';
    homepage = "https://particl.io/";
    maintainers = with maintainers; [ demyanrogozhin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
