{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  writeText,
  cmake,
  libxslt,
  docbook_xsl_ns,
  wrapQtAppsHook,
  libusb1,
  qtlocation,
  qtserialport,
  qttools,
  qtbase,
  yaml-cpp,
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "qdmr";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "hmatuschek";
    repo = "qdmr";
    rev = "v${version}";
    sha256 = "sha256-YLGsKGcKIPd0ihd5IzlT71dYkxZfeH7BpnKQMEyY8dI=";
  };

  nativeBuildInputs = [
    cmake
    libxslt
    wrapQtAppsHook
    installShellFiles
  ];

  buildInputs = [
    libusb1
    qtlocation
    qtserialport
    qttools
    qtbase
    yaml-cpp
  ];

  postPatch = lib.optionalString isLinux ''
    substituteInPlace doc/docbook_man.debian.xsl \
      --replace /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook\.xsl ${docbook_xsl_ns}/xml/xsl/docbook/manpages/docbook.xsl
  '';

  cmakeFlags = [
    "-DBUILD_MAN=ON"
    "-DINSTALL_UDEV_RULES=OFF"
  ];

  postInstall = ''
    installManPage doc/dmrconf.1 doc/qdmr.1
    mkdir -p "$out/etc/udev/rules.d"
    cp ${src}/dist/99-qdmr.rules $out/etc/udev/rules.d/
  '';

  meta = {
    description = "GUI application and command line tool for programming DMR radios";
    homepage = "https://dm3mat.darc.de/qdmr/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ janik _0x4A6F ];
    platforms = lib.platforms.linux;
  };
}
