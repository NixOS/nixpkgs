{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  libxslt,
  docbook_xsl_ns,
  kdePackages,
  libusb1,
  librsvg,
  yaml-cpp,
}:

let
  inherit (stdenv.hostPlatform) isLinux;
in

stdenv.mkDerivation rec {
  pname = "qdmr";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "hmatuschek";
    repo = "qdmr";
    rev = "v${version}";
    hash = "sha256-aSnp4bC9tl9qIQ65RLMiPAEJg49S/U39TnSmLJ9Tcpc=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    installShellFiles
  ];

  buildInputs = [
    librsvg
    libusb1
    libxslt
    kdePackages.qtlocation
    kdePackages.qtserialport
    kdePackages.qttools
    kdePackages.qtbase
    kdePackages.qtpositioning
    yaml-cpp
  ];

  postPatch =
    let
      file = "doc/docbook_man.${if isLinux then "debian" else "macports"}.xsl";
      path =
        if isLinux then
          "/usr/share/xml/docbook/stylesheet/docbook-xsl"
        else
          "/opt/local/share/xsl/docbook-xsl-nons";
    in
    ''
      substituteInPlace ${file} \
        --replace ${path}/manpages/docbook\.xsl ${docbook_xsl_ns}/xml/xsl/docbook/manpages/docbook.xsl
    '';

  cmakeFlags = [
    "-DBUILD_MAN=ON"
    "-DCMAKE_INSTALL_FULL_MANDIR=share/man"
    "-DDOCBOOK2MAN_XSLT=docbook_man.${if isLinux then "debian" else "macports"}.xsl"
    "-DINSTALL_UDEV_RULES=OFF"
  ];

  postInstall = lib.optionalString isLinux ''
    mkdir -p "$out/etc/udev/rules.d"
    cp ${src}/dist/99-qdmr.rules $out/etc/udev/rules.d/
  '';

  doInstallCheck = true;

  meta = {
    description = "GUI application and command line tool for programming DMR radios";
    homepage = "https://dm3mat.darc.de/qdmr/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      _0x4A6F
      juliabru
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
