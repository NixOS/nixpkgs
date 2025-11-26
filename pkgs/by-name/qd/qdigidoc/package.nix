{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  flatbuffers,
  gettext,
  pkg-config,
  libdigidocpp,
  opensc,
  openldap,
  openssl,
  pcsclite,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "qdigidoc";
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "DigiDoc4-Client";
    tag = "v${version}";
    hash = "sha256-sp+qlWtsMZHyoG0OVKbhalgak5KIx7C7Rpp0PbKVxK8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    flatbuffers
    libdigidocpp
    opensc
    openldap
    openssl
    pcsclite
    qt6.qtbase
    qt6.qtsvg
  ];

  # qdigidoc needs a (somewhat recent) config, as well as a TSL list for signing to work.
  # To refresh, re-fetch and update what's in the vendor/ directory.
  cmakeFlags = [
    # If not provided before the build, qdigidoc tries to download a TSL list during the build.
    # We pass it in via TSL_URL, fetched from https://ec.europa.eu/tools/lotl/eu-lotl.xml.
    "-DTSL_URL=file://${./vendor/eu-lotl.xml}"
    # `config.{json,pub,rsa}`, from https://id.eesti.ee/config.{json,pub,rsa}.
    # The build system also looks for `config.{pub,rsa}` in the same directory,
    # all three files need to be present.
    "-DCONFIG_URL=file://${./vendor}/config.json"
  ];

  # qdigidoc4's `QPKCS11::reload()` dlopen()s "opensc-pkcs11.so" in QLibrary,
  # i.e. OpenSC's module is searched for in libQt5Core's DT_RUNPATH and fixing
  # qdigidoc4's DT_RUNPATH has no effect on Linux (at least OpenBSD's ld.so(1)
  # searches the program's runtime path as well).
  # LD_LIBRARY_PATH takes precedence for all calling objects, see dlopen(3).
  # https://github.com/open-eid/cmake/pull/35 might be an alternative.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/"
  ];

  meta = with lib; {
    description = "Qt-based UI for signing and verifying DigiDoc documents";
    mainProgram = "qdigidoc4";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      flokli
      mmahut
    ];
  };
}
