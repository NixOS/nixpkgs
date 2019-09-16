{ stdenv, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "widevine";
  version = "4.10.1196.0";

  src = fetchurl {
    url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    sha256 = "01c7nr7d2xs718jymicbk4ipzfx6q253109qv3lk4lryrrhvw14y";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src libwidevinecdm.so
    find .
  '';

  installPhase = ''
    install -vD libwidevinecdm.so $out/lib/libwidevinecdm.so
  '';

  meta = with stdenv.lib; {
    description = "Widevine support for Vivaldi";
    homepage = "https://www.widevine.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ betaboon ];
    platforms   = [ "x86_64-linux" ];
  };
}
