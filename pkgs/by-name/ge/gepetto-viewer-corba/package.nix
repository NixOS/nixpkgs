{
  boost,
  cmake,
  doxygen,
  fetchFromGitHub,
  fontconfig,
  gepetto-viewer,
  lib,
  pkg-config,
  python3Packages,
  libsForQt5,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gepetto-viewer-corba";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer-corba";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C7xrODoKCcyLPZr0+zZSZ/o5i5EeNsxCPXp2WrP28A4=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [ libsForQt5.qtbase ];

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
    python3Packages.omniorb
  ];

  propagatedBuildInputs = [
    python3Packages.boost
    python3Packages.gepetto-viewer
    python3Packages.omniorbpy
  ];

  doCheck = true;

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  meta = {
    homepage = "https://github.com/gepetto/gepetto-viewer-corba";
    description = "CORBA client/server for gepetto-viewer.";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
