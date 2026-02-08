{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netmask";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "tlby";
    repo = "netmask";
    rev = "v${finalAttrs.version}";
    sha256 = "1269bmdvl534wr0bamd7cqbnr76pnb14yn8ly4qsfg29kh7hrds6";
  };

  buildInputs = [ texinfo ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/tlby/netmask";
    description = "IP address formatting tool";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jensbin ];
    mainProgram = "netmask";
  };
})
