{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, leptonica, libpng, libtiff, icu, pango, opencl-headers
# Supported list of languages or `null' for all available languages
, enableLanguages ? null
# if you want just a specific list of languages, optionally specify a hash
# to make tessdata a fixed output derivation.
, enableLanguagesHash ? (if enableLanguages == null # all languages
                         then "1h48xfzabhn0ldbx5ib67cp9607pr0zpblsy8z6fs4knn0zznfnw"
                         else null)
}:

let tessdata = stdenv.mkDerivation ({
  name = "tessdata";
  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata";
    rev = "3cf1e2df1fe1d1da29295c9ef0983796c7958b7d";
    # when updating don't forget to update the default value fo enableLanguagesHash
    sha256 = "1v4b63v5nzcxr2y3635r19l7lj5smjmc9vfk0wmxlryxncb4vpg7";
  };
  buildCommand = ''
    cd $src;
    for lang in ${if enableLanguages==null then "*.traineddata" else stdenv.lib.concatMapStringsSep " " (x: x+".traineddata") enableLanguages} ; do
      install -Dt $out/share/tessdata $src/$lang ;
    done;
  '';
  preferLocalBuild = true;
  } // (stdenv.lib.optionalAttrs (enableLanguagesHash != null) {
  # when a hash is given, we make this a fixed output derivation.
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = enableLanguagesHash;
  }));
in

stdenv.mkDerivation rec {
  name = "tesseract-${version}";
  version = "3.05.00";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "11wrpcfl118wxsv2c3w2scznwb48c4547qml42s2bpdz079g8y30";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

  LIBLEPT_HEADERSDIR = "${leptonica}/include";

  postInstall = ''
    for i in ${tessdata}/share/tessdata/*; do
      ln -s $i $out/share/tessdata;
    done
  '';

  meta = {
    description = "OCR engine";
    homepage = https://github.com/tesseract-ocr/tesseract;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
