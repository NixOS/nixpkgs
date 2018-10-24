{ stdenv, cmake, extra-cmake-modules, plasma-framework, kwindowsystem, plasma-pa, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "plasma-applet-volumewin7mixer-${version}";
  version = "23";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "plasma-applet-volumewin7mixer";
    rev = "v${version}";
    sha256 = "1j2bq343lnhwqz26qfsvg7vjxv84ibzbc4y86rjkh07nqjwb3xsc";
  };

  patches = [ ./cmake.patch ];
  postPatch = '' rm build '';
  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ plasma-framework kwindowsystem plasma-pa ];

  meta = with stdenv.lib; {
    description = "A fork of the default volume plasmoid with a Windows 7 theme (vertical sliders).";
    homepage = "https://github.com/Zren/plasma-applet-volumewin7mixer";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
