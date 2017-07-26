{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, leptonica, libpng, libtiff, icu, pango, opencl-headers

# Supported list of languages or `null' for all available languages
, enableLanguages ? null
}:

stdenv.mkDerivation rec {
  name = "tesseract-${version}";
  version = "3.05.00";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "11wrpcfl118wxsv2c3w2scznwb48c4547qml42s2bpdz079g8y30";
  };

  tessdata = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata";
    rev = "3cf1e2df1fe1d1da29295c9ef0983796c7958b7d";
    sha256 = "1v4b63v5nzcxr2y3635r19l7lj5smjmc9vfk0wmxlryxncb4vpg7";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

  LIBLEPT_HEADERSDIR = "${leptonica}/include";

  # Copy the .traineddata files of the languages specified in enableLanguages
  # into `$out/share/tessdata' and check afterwards if copying was successful.
  postInstall = let
    mkArg = lang: "-iname ${stdenv.lib.escapeShellArg "${lang}.traineddata"}";
    mkFindArgs = stdenv.lib.concatMapStringsSep " -o " mkArg;
    findLangArgs = if enableLanguages != null
                   then "\\( ${mkFindArgs enableLanguages} \\)"
                   else "-iname '*.traineddata'";
  in ''
    numLangs="$(find "$tessdata" -mindepth 1 -maxdepth 1 -type f \
      ${findLangArgs} -exec cp -t "$out/share/tessdata" {} + -print | wc -l)"

    ${if enableLanguages != null then ''
      expected=${toString (builtins.length enableLanguages)}
    '' else ''
      expected="$(ls -1 "$tessdata/"*.traineddata | wc -l)"
    ''}

    if [ "$numLangs" -ne "$expected" ]; then
      echo "Expected $expected languages, but $numLangs" \
           "were copied to \`$out/share/tessdata'" >&2
      exit 1
    fi
  '';

  meta = {
    description = "OCR engine";
    homepage = http://code.google.com/p/tesseract-ocr/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
