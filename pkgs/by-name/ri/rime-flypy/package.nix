{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  librime,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "rime-flypy";
  version = "20240827";
  srcs = [
    (fetchFromGitHub {
      owner = "rime";
      repo = "rime-prelude";
      name = "prelude";
      rev = "3c602fdb0dcca7825103e281efc50ef7580f99ec";
      sha256 = "R9sxeCe1e2A3pn//iGwRr3eTTpgxprjEEjlo15/O19c=";
    })
    (fetchFromGitHub {
      owner = "cubercsl";
      repo = pname;
      name = pname;
      tag = "v${version}";
      sha256 = "shXcDjAaClemaOsE9ajZBedUzYKLw+ZATDTuyAu+zUc=";
    })
  ];
  sourceRoot = ".";
  preBuild = ''
    mv prelude/* ${pname}
    cd ${pname}
  '';
  makeFlags = [
    "PREFIX=$(out)"
  ];
  nativeBuildInputs = [
    librime
  ];
  meta = {
    description = "flypy schema for rime";
    longDescription = "小鹤音形 rime 挂接文件";
    homepage = "https://flypy.cc";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ yaoheng ];
    license = lib.licenses.unfree;
  };
}
