{ stdenv, lib, fetchurl, meson, ninja, pkg-config, glm, libevdev, libxml2 }:

stdenv.mkDerivation rec {
  pname = "wf-config";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wf-config/releases/download/v${version}/wf-config-${version}.tar.xz";
    sha256 = "1bas5gsbnf8jxkkxd95992chz8yk5ckgg7r09gfnmm7xi8w0pyy7";
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
