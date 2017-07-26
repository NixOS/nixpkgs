{ stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkgconfig
, leptonica, libpng, libtiff, icu, pango, opencl-headers

# Supported list of languages or `null' for all available languages
, enableLanguages ? null
}:

stdenv.mkDerivation rec {
  name = "tesseract-${version}";
  version = "4.00.00alpha-git-20170410";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = "36a995bdc92eb2dd8bc5a63205708944a3f990a1";
    sha256 = "0xz3krvap8sdm27v1dyb34lcdmx11wzvxyszpppfsfmjgkvg19bq";
  };

  tessdata = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata";
    rev = "8bf2e7ad08db9ca174ae2b0b3a7498c9f1f71d40";
    sha256 = "0idwkv4qsmmqhrxcgyhy32yldl3vk054m7dkv4fjswfnalgsx794";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook autoconf-archive ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

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
    platforms = with stdenv.lib.platforms; linux;
  };
}
