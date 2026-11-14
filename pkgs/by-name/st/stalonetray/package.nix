{
  cmake,
  docbook_xml_dtd_44,
  docbook-xsl-ns,
  fetchFromGitHub,
  lib,
  libx11,
  libxinerama,
  libxpm,
  libxrandr,
  libxslt,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stalonetray";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "d3adb5";
    repo = "stalonetray";
    rev = finalAttrs.version;
    sha256 = "sha256-8qf9WFvYdvBnX+Eca8vkAMDYkmEra9B9q+RkRhIXkX4=";
  };

  preConfigure =
    let
      docbook_loop = "for root in";
    in
    ''
      substituteInPlace generate-manpage.sh --replace '${docbook_loop} \' '${docbook_loop} ${docbook-xsl-ns}/share/xml/docbook-xsl-ns \'
    '';

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    docbook-xsl-ns
    docbook_xml_dtd_44
  ];
  buildInputs = [
    libx11
    libxinerama
    libxrandr
    libxpm
    libxslt
  ];
  mesonFlags = [
    "-Dtests=disabled"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Stand alone tray";
    homepage = "https://github.com/d3adb5/stalonetray";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ raskin ];
    mainProgram = "stalonetray";
  };
})
