{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.53";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-WvR4QT03hLCX3qq1dM20zuaYkwfSkqK6PGeC7gJOUU0=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.lukas-sgx ];
    platforms = lib.platforms.linux;
    mainProgram = "mxt-app";
  };
})
