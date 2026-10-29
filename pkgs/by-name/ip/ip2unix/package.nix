{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  yaml-cpp,
  systemd,
  python3Packages,
  asciidoc,
  libxslt,
  docbook_xml_dtd_45,
  docbook_xsl,
  libxml2,
  docbook5,
  mesonEmulatorHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ip2unix";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "ip2unix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QWhOO2tHl8fwXy0k9W+I/XHPJI8OJyexMsgOSJes37s";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoc
    libxslt.bin
    docbook_xml_dtd_45
    docbook_xsl
    libxml2.bin
    docbook5
    python3Packages.pytest
    python3Packages.pytest-timeout
    systemd
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

  buildInputs = [ yaml-cpp ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    found=0
    for man in "$out/share/man/man1"/ip2unix.1*; do
      test -s "$man" && found=1
    done
    if [ $found -ne 1 ]; then
      echo "ERROR: Manual page hasn't been generated." >&2
      exit 1
    fi
  '';

  meta = {
    homepage = "https://github.com/nixcloud/ip2unix";
    description = "Turn IP sockets into Unix domain sockets";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.aszlig ];
    mainProgram = "ip2unix";
  };
})
