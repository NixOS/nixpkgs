{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  librime,
}:
let
  prelude = fetchFromGitHub {
    owner = "rime";
    repo = "rime-prelude";
    rev = "3c602fdb0dcca7825103e281efc50ef7580f99ec";
    hash = "sha256-R9sxeCe1e2A3pn//iGwRr3eTTpgxprjEEjlo15/O19c=";
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "rime-flypy";
  version = "20240827";
  src = fetchFromGitHub {
    owner = "cubercsl";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-shXcDjAaClemaOsE9ajZBedUzYKLw+ZATDTuyAu+zUc=";
  };
  preBuild = "cp ${prelude}/* .";
  makeFlags = [
    "PREFIX=$(out)"
  ];
  nativeBuildInputs = [
    librime
  ];
  meta = {
    description = "flypy schema for rime(小鹤音形 rime 挂接文件)";
    homepage = "https://flypy.cc";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ yaoheng ];
    license = lib.licenses.unfree;
  };
}
