{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {

  pname = "kytea";
  version = "0.4.7";

  src = fetchurl {
    url = "http://www.phontron.com/kytea/download/${pname}-${version}.tar.gz";
    sha256 = "0ilzzwn5vpvm65bnbyb9f5rxyxy3jmbafw9w0lgl5iad1ka36jjk";
  };

  patches = [ ./gcc-O3.patch ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  meta = with lib; {
    homepage = "http://www.phontron.com/kytea/";
    description = "General toolkit developed for analyzing text";

    longDescription = ''
      A general toolkit developed for analyzing text, with a focus on Japanese,
      Chinese and other languages requiring word or morpheme segmentation.
    '';

    license = licenses.asl20;

    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.unix;
  };

}
