{ stdenv
, lib
, fetchFromGitHub
, qmake
, qtbase
, qtdeclarative
, qtquickcontrols
, wrapQtAppsHook
}:
stdenv.mkDerivation rec {
  pname = "firebird-emu";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "nspire-emus";
    repo = "firebird";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ZptjlnOiF+hKuKYvBFJL95H5YQuR99d4biOco/MVEmE=";
  };

  # work around https://github.com/NixOS/nixpkgs/issues/19098
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.cc.isClang && stdenv.isDarwin) "-fno-lto";

  nativeBuildInputs = [ wrapQtAppsHook qmake ];

  buildInputs = [ qtbase qtdeclarative qtquickcontrols ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/${pname}.app $out/Applications/
  '';

  meta = {
    homepage = "https://github.com/nspire-emus/firebird";
    description = "Third-party multi-platform emulator of the ARM-based TI-Nspire™ calculators";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pneumaticat ];
    platforms = lib.platforms.unix;
  };
}
