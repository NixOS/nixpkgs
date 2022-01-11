{ lib, stdenv, cmake, extra-cmake-modules, plasma-framework, kwindowsystem, plasma-pa, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "plasma-applet-commandoutput";
  version = "2022-01-11";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "plasma-applet-commandoutput";
    rev = "d4c93a1fad82ff4d2fcc622f592b28a60878f49f";
    sha256 = "0hg5i8yq159263yz7jyhpi893c5c2kl59w03p9nnpw656xr6102b";
  };

  # Adds the CMakeLists.txt not provided by upstream
  patches = [ ./cmake.patch ];
  postPatch = "rm build";
  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ plasma-framework kwindowsystem plasma-pa ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Run command every second and displays the output.";
    homepage = "https://github.com/Zren/plasma-applet-commandoutput";
    platforms = platforms.linux;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

