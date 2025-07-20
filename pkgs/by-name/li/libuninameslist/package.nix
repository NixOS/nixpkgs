{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20250714";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "libuninameslist";
    rev = version;
    hash = "sha256-2SC8hu4yHbSbmQL17bfF4BwPLzBhUvF8iGqEtueUZaU=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    homepage = "https://github.com/fontforge/libuninameslist/";
    changelog = "https://github.com/fontforge/libuninameslist/blob/${version}/ChangeLog";
    description = "Library of Unicode names and annotation data";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
    platforms = lib.platforms.all;
  };
}
