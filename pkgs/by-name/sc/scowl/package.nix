{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  zip,
  libiconv,
  perl,
  aspell,
  dos2unix,
  singleWordlist ? null,
}:

stdenv.mkDerivation rec {
  pname = "scowl";
  version = "2020.12.07";

  src = fetchFromGitHub {
    owner = "en-wl";
    repo = "wordlist";
    rev = "rel-${version}";
    sha256 = "sha256-J61jhpnZcXMnoGlSuSCrKDZnnyp3Snjr+fUpTVKX64g=";
  };

  postPatch = ''
    substituteInPlace scowl/src/Makefile \
        --replace g++ c++
  '';

  nativeBuildInputs = [
    unzip
    zip
    perl
    aspell
    dos2unix
  ];
  buildInputs = lib.optional (!stdenv.hostPlatform.isLinux) libiconv;

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  preConfigure = ''
    patchShebangs .
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}$PWD/varcon"
  '';

  postBuild = lib.optionalString (singleWordlist == null) ''
    (
    cd scowl/speller
    make aspell
    make hunspell
    )
  '';

  enableParallelBuilding = false;

  installPhase =
    if singleWordlist == null then
      ''
        eval "$preInstall"

        mkdir -p "$out/share/scowl"
        mkdir -p "$out/lib" "$out/share/hunspell" "$out/share/myspell"
        mkdir -p "$out/share/dict"

        cp -r scowl/speller/aspell "$out/lib/aspell"
        cp scowl/speller/*.{aff,dic} "$out/share/hunspell"
        ln -s "$out/share/hunspell" "$out/share/myspell/dicts"

        cp scowl/final/* "$out/share/scowl"

        (
          cd scowl
          for region in american british british_s british_z canadian australian; do
            case $region in
              american)
                regcode=en-us;
                ;;
              british)
                regcode=en-gb-ise;
                ;;
              british_s)
                regcode=en-gb-ise;
                ;;
              british_z)
                regcode=en-gb-ize;
                ;;
              canadian)
                regcode=en-ca;
                ;;
              australian)
                regcode=en-au;
                ;;
            esac
            regcode_var="$regcode"
            if test "$region" = british; then
              regcode_var="en-gb"
            fi

            echo $region $regcode $regcode_sz
            for s in 10 20 30 35 40 50 55 60 70 80 90 95; do
              ./mk-list $regcode $s > "$out/share/dict/w$region.$s"
              ./mk-list --variants=1 $regcode_var $s > "$out/share/dict/w$region.variants.$s"
              ./mk-list --variants=2 $regcode_var $s > "$out/share/dict/w$region.acceptable.$s"
            done
            ./mk-list $regcode 60 > "$out/share/dict/w$region.txt"
            ./mk-list --variants=1 $regcode_var 60 > "$out/share/dict/w$region.variants.txt"
            ./mk-list --variants=2 $regcode_var 80 > "$out/share/dict/w$region.scrabble.txt"
          done
          ./mk-list --variants=1 en-gb 60 > "$out/share/dict/words.variants.txt"
          ./mk-list --variants=1 en-gb 80 > "$out/share/dict/words.scrabble.txt"
          ./mk-list en-gb-ise 60 > "$out/share/dict/words.txt"
        )

        eval "$postInstall"
      ''
    else
      ''
        mkdir -p "$out/share/dict"
        cd scowl
        ./mk-list ${singleWordlist} > "$out/share/dict/words.txt"
      '';

  meta = {
    description = "Spell checker oriented word lists";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "http://wordlist.aspell.net/";
  };
}
