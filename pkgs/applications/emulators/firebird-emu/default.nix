{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase, qtdeclarative }:

mkDerivation rec {
  pname = "firebird-emu";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "nspire-emus";
    repo = "firebird";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ZptjlnOiF+hKuKYvBFJL95H5YQuR99d4biOco/MVEmE=";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase qtdeclarative ];

  meta = {
    homepage = "https://github.com/nspire-emus/firebird";
    description = "Third-party multi-platform emulator of the ARM-based TI-Nspire™ calculators";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pneumaticat ];
    # Only tested on Linux, but likely possible to build on, e.g. macOS
    platforms = lib.platforms.linux;
  };
}
