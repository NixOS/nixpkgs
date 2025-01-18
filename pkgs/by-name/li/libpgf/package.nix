{
  lib,
  stdenv,
  fetchzip,
  autoreconfHook,
  dos2unix,
}:

stdenv.mkDerivation rec {
  pname = "libpgf";
  version = "7.21.7";

  src = fetchzip {
    url = "mirror://sourceforge/${pname}/${pname}/${version}/${pname}.zip";
    hash = "sha256-TAWIuikijfyeTRetZWoMMdB/FeGAR7ZjNssVxUevlVg=";
  };

  postPatch = ''
    find . -type f | xargs dos2unix
    mv README.txt README
  '';

  nativeBuildInputs = [
    autoreconfHook
    dos2unix
  ];

  meta = with lib; {
    homepage = "https://www.libpgf.org/";
    description = "Progressive Graphics Format";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
