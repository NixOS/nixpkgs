{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  texinfo,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netmask";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "tlby";
    repo = "netmask";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BXCZsk+52nygxtY1s4C79WCwy/iOSwgRnQYnauWGipQ=";
  };

  buildInputs = [ texinfo ];
  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  nativeCheckInputs = [ check ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/tlby/netmask";
    description = "IP address formatting tool";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jensbin ];
    mainProgram = "netmask";
  };
})
