{ fetchurl, lib, stdenv, libX11, libXext, libXv, libpng }:

stdenv.mkDerivation rec {
  pname = "qemacs";
  version = "0.3.3";

  src = fetchurl {
    url = "https://bellard.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "156z4wpj49i6j388yjird5qvrph7hz0grb4r44l4jf3q8imadyrg";
  };

  buildInputs = [ libpng libX11 libXext libXv ];

  preInstall = ''
    mkdir -p $out/bin $out/man
  '';

  meta = with lib; {
    homepage = "https://bellard.org/qemacs/";
    description = "Very small but powerful UNIX editor";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ iblech ];
  };
}
