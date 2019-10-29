{ stdenv, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "widevine";
  version = "4.10.1582.1";

  src = fetchurl {
    url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    sha256 = "0l743f2yyaq1vvc3iicajgnfpjxjsfvjcqvanndbxs23skgjcv6r";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
    install -vD LICENSE.txt $out/share/google/chrome/WidevineCdm/LICENSE.txt
    install -vD libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
  '';

  meta = with stdenv.lib; {
    description = "Widevine support for Vivaldi";
    homepage = "https://www.widevine.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ betaboon ];
    platforms   = [ "x86_64-linux" ];
  };
}
