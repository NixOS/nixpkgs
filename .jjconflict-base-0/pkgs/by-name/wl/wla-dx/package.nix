{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "wla-dx";
  version = "10.6";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    tag = "v${version}";
    hash = "sha256-t+X1Y1NhAGi4NOPik2fuLZAR3A7NQMAkSgWvqAFaIik=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install binaries/* $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://www.villehelin.com/wla.html";
    description = "Yet Another GB-Z80/Z80/6502/65C02/6510/65816/HUC6280/SPC-700 Multi Platform Cross Assembler Package";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ matthewbauer ];
    platforms = lib.platforms.all;
  };
}
