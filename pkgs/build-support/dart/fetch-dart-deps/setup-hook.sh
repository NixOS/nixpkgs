preConfigureHooks+=(_setupPubCache)

_setupPubCache() {
    deps="@deps@"

    # Configure the package cache.
    export PUB_CACHE="$(mktemp -d)"
    mkdir -p "$PUB_CACHE"

    if [ -d "$deps/cache/.pub-cache/git" ]; then
        # Link the Git package cache.
        mkdir -p "$PUB_CACHE/git"
        ln -s "$deps/cache/.pub-cache/git"/* "$PUB_CACHE/git"

        # Recreate the internal Git cache subdirectory.
        # See: https://github.com/dart-lang/pub/blob/c890afa1d65b340fa59308172029680c2f8b0fc6/lib/src/source/git.dart#L339)
        # Blank repositories are created instead of attempting to match the cache mirrors to checkouts.
        # This is not an issue, as pub does not need the mirrors in the Flutter build process.
        rm "$PUB_CACHE/git/cache" && mkdir "$PUB_CACHE/git/cache"
        for mirror in $(ls -A "$deps/cache/.pub-cache/git/cache"); do
            git --git-dir="$PUB_CACHE/git/cache/$mirror" init --bare --quiet
        done
    fi

    # Link the remaining package cache directories.
    # At this point, any subdirectories that must be writable must have been taken care of.
    for file in $(comm -23 <(ls -A "$deps/cache/.pub-cache") <(ls -A "$PUB_CACHE")); do
        ln -s "$deps/cache/.pub-cache/$file" "$PUB_CACHE/$file"
    done

    # ensure we're using a lockfile for the right package version
    if [ ! -e pubspec.lock ]; then
        cp -v "$deps/pubspec/pubspec.lock" .
        # Sometimes the pubspec.lock will get opened in write mode, even when offline.
        chmod u+w pubspec.lock
    elif ! { diff -u pubspec.lock "$deps/pubspec/pubspec.lock" && diff -u pubspec.yaml "$deps/pubspec/pubspec.yaml"; }; then
        echo 1>&2 -e 'The pubspec.lock or pubspec.yaml of the project derivation differs from the one in the dependency derivation.' \
                   '\nYou most likely forgot to update the vendorHash while updating the sources.'
        exit 1
    fi
}
