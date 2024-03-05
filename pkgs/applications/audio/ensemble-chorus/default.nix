{ lib, stdenv, fetchFromGitHub, fltk, alsa-lib, freetype, libXrandr, libXinerama, libXcursor, lv2, libjack2, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ensemble-chorus";
  version = "0-unstable-2019-02-15";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "59baeb86b8851f521bc8162e22e3f15061662cc3";
    sha256 = "0c1y10vyhrihcjvxqpqf6b52yk5yhwh813cfp6nla5ax2w88dbhr";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    fltk alsa-lib freetype libXrandr libXinerama libXcursor lv2 libjack2
  ];

  meta = with lib; {
    homepage = "https://github.com/jpcima/ensemble-chorus";
    description = "Digital model of electronic string ensemble chorus";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.boost;
  };
}
