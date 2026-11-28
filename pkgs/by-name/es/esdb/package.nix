{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  sqlite,
  perl,
  aspell,
  hunspell,
  zip,
  dos2unix,
  libiconv,
  singleWordlist ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "esdb";
  version = "2026.02.25";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "en-wl";
    repo = "wordlist";
    tag = "rel-${finalAttrs.version}";
    hash = "sha256-YDQ3lHfx67b0JUSaUY888RmBVOVVq0Q2CyhY9Lbc+fE=";
  };

  postPatch = ''
    patchShebangs --build combine.py mk-list scowl speller

    substituteInPlace speller/Makefile \
      --replace-fail '/bin/bash' "$(type -P bash)"

    substituteInPlace speller/HEADER.sh \
      --replace-fail '`date`' '`date -u -d "@$SOURCE_DATE_EPOCH"`'
  '';

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals (singleWordlist == null) [
    sqlite
    perl
    aspell
    hunspell
    zip
    dos2unix
  ]
  ++ lib.optional (!stdenv.buildPlatform.isLinux) libiconv;

  env.SCOWL_VERSION = finalAttrs.version;

  postBuild = lib.optionalString (singleWordlist == null) ''
    make -C speller hunspell
  '';

  enableParallelBuilding = false;

  installPhase =
    if singleWordlist == null then
      ''
        runHook preInstall

        mkdir -p "$out/share/hunspell" "$out/share/myspell" "$out/share/dict"

        cp speller/*.{aff,dic} "$out/share/hunspell"
        ln -s "$out/share/hunspell" "$out/share/myspell/dicts"

        for region in american british british_s british_z canadian australian; do
          case $region in
            american)
              regcode=en-us
              ;;
            british | british_s)
              regcode=en-gb-ise
              ;;
            british_z)
              regcode=en-gb-ize
              ;;
            canadian)
              regcode=en-ca
              ;;
            australian)
              regcode=en-au
              ;;
          esac
          regcode_var="$regcode"
          if test "$region" = british; then
            regcode_var=en-gb
          fi

          # --variants selects only those variant levels, without the base list.
          for s in 35 40 50 60 65 70 80 85; do
            ./mk-list $regcode $s > "$out/share/dict/w$region.$s"
            ./mk-list --variants 1 $regcode_var $s > "$out/share/dict/w$region.variants.$s"
            ./mk-list --variants 1,2 $regcode_var $s > "$out/share/dict/w$region.acceptable.$s"
          done
          ./mk-list $regcode 60 > "$out/share/dict/w$region.txt"
          ./mk-list --variants 1 $regcode_var 60 > "$out/share/dict/w$region.variants.txt"
          ./mk-list --variants 1,2 $regcode_var 80 > "$out/share/dict/w$region.scrabble.txt"
        done
        ./mk-list --variants 1 en-gb 60 > "$out/share/dict/words.variants.txt"
        ./mk-list --variants 1 en-gb 80 > "$out/share/dict/words.scrabble.txt"
        ./mk-list en-gb-ise 60 > "$out/share/dict/words.txt"

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p "$out/share/dict"
        ./mk-list ${singleWordlist} > "$out/share/dict/words.txt"

        runHook postInstall
      '';

  meta = {
    description = "Spell checker oriented word lists";
    license =
      with lib.licenses;
      AND [
        # non-AU scowl wordlists
        (mkLicense {
          shortName = "scowl";
          fullName = "SCOWL License";
          url = "https://github.com/en-wl/wordlist/blob/rel-${finalAttrs.version}/Copyright";
        })
        # AU scowl wordlists
        # SPDX HPND-sell-variant, but with "this array" instead of "this software"
        (mkLicense {
          shortName = "scowl-au";
          fullName = "SCOWL Australian English License (Titze)";
          url = "https://github.com/en-wl/wordlist/blob/rel-${finalAttrs.version}/Copyright";
        })
        advancedCrypticsDictionary
        # hunspell dictionaries
        bsdMarkModifications
      ];
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://wordlist.aspell.net/";
  };
})
