{ stdenv, makeWrapper, tesseractBase, languages

# A list of languages like [ "eng" "spa" … ] or `null` for all available languages
, enableLanguages ? null

# A list of files or a directory containing files
, tessdata ? (if enableLanguages == null then languages.all
              else map (lang: languages.${lang}) enableLanguages)

# This argument is obsolete
, enableLanguagesHash ? null
}:

let
  passthru = { inherit tesseractBase languages tessdata; };

  tesseractWithData = tesseractBase.overrideAttrs (_: {
    inherit tesseractBase tessdata;

    buildInputs = [ makeWrapper ];

    buildCommand = ''
      makeWrapper {$tesseractBase,$out}/bin/tesseract --set-default TESSDATA_PREFIX $out/share/tessdata

      # Recursively link include, share
      cp -rs --no-preserve=mode $tesseractBase/{include,share} $out

      cp -r --no-preserve=mode $tesseractBase/lib $out
      # Fixup the store paths in lib so that the tessdata from this derivation is used.
      if (( ''${#tesseractBase} != ''${#out} )); then
        echo "Can't replace store paths due to differing lengths"
        exit 1
      fi
      find $out/lib -type f -exec sed -i "s|$tesseractBase|$out|g" {} \;

      if [[ -d "$tessdata" ]]; then
        ln -s $tessdata/* $out/share/tessdata
      else
        for lang in $tessdata; do
          ln -s $lang $out/share/tessdata/''${lang#/nix/store*-}
        done
      fi

      if [[ ! -e $out/share/tessdata/eng.traineddata ]]; then
         # This is a bug in Tesseract's internal tessdata discovery mechanism
         echo "eng.traineddata must be present in tessdata for Tesseract to work"
         exit 1
      fi
    '';
  });

  tesseract = (if enableLanguages == [] then tesseractBase else tesseractWithData) // passthru;
in
  if enableLanguagesHash == null then
    tesseract
  else
    stdenv.lib.warn "Argument `enableLanguagesHash` is obsolete and can be removed."
    tesseract
