{ stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkgconfig
, leptonica, libpng, libtiff, icu, pango, opencl-headers

# Supported list of languages or `null' for all available languages
, enableLanguages ? null
}:

stdenv.mkDerivation rec {
  name = "tesseract-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "1b5fi2vibc4kk9b30kkk4ais4bw8fbbv24bzr5709194hb81cav8";
  };

  tessdata = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata";
    rev = version;
    sha256 = "1chw1ya5zf8aaj2ixr9x013x7vwwwjjmx6f2ag0d6i14lypygy28";
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
    homepage = https://github.com/tesseract-ocr/tesseract;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
