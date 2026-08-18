unpackPhase="unpackGog"

unpackGog() {
    runHook preUnpackGog

    innoextract --silent --extract --exclude-temp "${src}"

    find . -depth -print -execdir rename -f 'y/A-Z/a-z/' '{}' \;

    runHook postUnpackGog
}
