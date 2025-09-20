{
  lib,
  stdenv,
  fetchurl,
  cmake,
  openal,
}:

stdenv.mkDerivation rec {
  pname = "alure";
  version = "1.2";

  src = fetchurl {
    url = "https://web.archive.org/web/20190529213651if_/https://kcat.strangesoft.net/alure-releases/alure-${version}.tar.bz2";
    hash = "sha256-Rl5q2uaJJ746AjkDdkZi1kQE5AxMFS0WDjqIOLHXD3E=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openal ];

  meta = with lib; {
    description = "Utility library to help manage common tasks with OpenAL applications";
    homepage = "https://github.com/kcat/alure";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
