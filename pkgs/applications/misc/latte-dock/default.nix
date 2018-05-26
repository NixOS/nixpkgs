{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchFromGitHub
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, kcrash }:

let version = "0.7.5"; in

mkDerivation {
  name = "latte-dock-${version}";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "Latte-Dock";
    rev = "v${version}";
    sha256 = "0fblbx6qk4miag1mhiyns7idsw03p9pj3xc3xxxnb5rpj1fy0ifv";
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
