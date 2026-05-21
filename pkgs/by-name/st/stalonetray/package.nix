{
  autoreconfHook,
  docbook_xml_dtd_44,
  docbook-xsl-ns,
  fetchFromGitHub,
  lib,
  libx11,
  libxpm,
  libxslt,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stalonetray";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "kolbusa";
    repo = "stalonetray";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/55oP6xA1LeLawOBkhh9acaDcObO4L4ojcy7e3vwnBw=";
  };

  preConfigure =
    let
      db_root = "${docbook-xsl-ns}/share/xml/docbook-xsl-ns";
      ac_str = "AC_SUBST(DOCBOOK_ROOT)";
      ac_str_sub = "DOCBOOK_ROOT=${db_root}; ${ac_str}";
    in
    ''
      substituteInPlace configure.ac --replace '${ac_str}' '${ac_str_sub}'
    '';

  nativeBuildInputs = [
    autoreconfHook
    docbook-xsl-ns
    docbook_xml_dtd_44
    libx11
    libxpm
    libxslt
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Stand alone tray";
    homepage = "https://github.com/kolbusa/stalonetray";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ raskin ];
    mainProgram = "stalonetray";
  };
})
