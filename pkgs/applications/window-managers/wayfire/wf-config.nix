{ stdenv, lib, fetchurl, meson, ninja, pkg-config, glm, libevdev, libxml2 }:

stdenv.mkDerivation rec {
  pname = "wf-config";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wf-config/releases/download/${version}/wf-config-${version}.tar.xz";
    sha256 = "1a5aqybhbp9dp4jygrm3gbkdap5qbd52y6ihfr4rm1cj37sckcn0";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libevdev libxml2 ];
  propagatedBuildInputs = [ glm ];

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
