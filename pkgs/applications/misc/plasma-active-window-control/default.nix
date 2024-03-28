{ mkDerivation, extra-cmake-modules, plasma-framework, qtx11extras, fetchFromGitLab, lib, cmake, qtbase, libSM }:

mkDerivation rec {
  version = "1.1.0";
  pname = "plasma-active-window-control";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = pname;
    rev = "c36e51c0e3a809ab166b619f130dcf20c8d5f61c";
    sha256 = "sha256-6hF7ppY9LyLsborsC3iBCmhE/EucGG7en2TeomjdVkQ=";
  };

  buildInputs = [
    plasma-framework
    qtbase
    qtx11extras
    libSM
  ];

  nativeBuildInputs = [cmake extra-cmake-modules];

  meta = with lib; {
    description = "Active Window Control applet for the Plasma Desktop ";
    homepage = "https://invent.kde.org/plasma/plasma-active-window-control";
    license = licenses.gpl2Only or licenses.gpl3Only;
    maintainers = with maintainers; [ icewind1991 ];
    platforms = platforms.unix;
  };
}
