{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchFromGitHub
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, kcrash }:

let version = "0.7.4"; in

mkDerivation {
  name = "latte-dock-${version}";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "Latte-Dock";
    rev = "v${version}";
    sha256 = "0w4fphgpdvql31wrypxyfahmr4cv5ap96wjc4270yyawnrqrx0y6";
  };

  buildInputs = [ plasma-framework xorg.libpthreadstubs xorg.libXdmcp xorg.libSM ];

  nativeBuildInputs = [ extra-cmake-modules cmake karchive kwindowsystem
    qtx11extras kcrash ];

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = https://github.com/psifidotos/Latte-Dock;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.benley ];
  };
}
