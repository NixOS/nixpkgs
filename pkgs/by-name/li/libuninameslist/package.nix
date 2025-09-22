{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20250909";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "libuninameslist";
    rev = version;
    hash = "sha256-jLl9UY24wIBkMxr/zq/yXRcKgwlHFG8zmoyo3YKqq9A=";
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
