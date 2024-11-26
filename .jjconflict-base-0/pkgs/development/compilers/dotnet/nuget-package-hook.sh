# shellcheck shell=bash disable=SC2154

unpackNupkg() {
    local -r nupkg="$1" unpacked="$2"
    local nuspec nuspec_l

    mkdir -p "$unpacked"
    @unzip@/bin/unzip -nqd "$unpacked" "$nupkg"
    cd "$unpacked"
    chmod -R +rw .
    nuspec=(*.nuspec)
    nuspec_l="${nuspec,,}"
    if [[ $nuspec != "$nuspec_l" ]]; then
        mv "$nuspec" "$nuspec".tmp
        mv "$nuspec".tmp "$nuspec_l"
    fi
    echo {} > .nupkg.metadata
    cd - >/dev/null
}

_unpackNugetPackagesInOutput() {
    local -r unpacked="$prefix"/share/nuget/packages/.unpacked
    local nuspec nuspec_l
    (
        shopt -s nullglob globstar
        for nupkg in "$prefix"/share/nuget/source/**/*.nupkg; do
            unpackNupkg "$nupkg" "$unpacked"
            @xmlstarlet@/bin/xmlstarlet \
                sel -t \
                -m /_:package/_:metadata \
                -v _:id -nl \
                -v _:version -nl \
                "$unpacked"/*.nuspec | (
                read id
                read version
                id=''${id,,}
                version=''${version,,}
                mkdir -p "$prefix"/share/nuget/packages/"$id"
                mv "$unpacked" "$prefix"/share/nuget/packages/"$id"/"$version"
            )
        done
        rm -rf "$prefix"/share/nuget/source
    )
}

unpackNugetPackages() {
    local output
    for output in $(getAllOutputNames); do
        prefix="${!output}" _unpackNugetPackagesInOutput
    done
}

if [[ -z ${dontUnpackNugetPackages-} ]]; then
    preFixupHooks+=(unpackNugetPackages)
fi

_createNugetSourceInOutput() {
    local package version id dir nupkg content
    local -a nuspec
    (
        shopt -s nullglob

        for package in "$prefix"/share/nuget/packages/*/*; do
            version=$(basename "$package")
            id=$(basename "$(dirname "$package")")
            dir="$prefix/share/nuget/source/$id/$version"
            nupkg=$dir/$id.$version.nupkg
            nuspec=("$package"/*.nuspec)

            if [[ -n ${createInstallableNugetSource-} ]]; then
                content=.
            else
                content=$(basename "${nuspec[0]}")
            fi

            mkdir -p "$dir"
            cp "${nuspec[0]}" "$dir/$id.nuspec"
            (cd "$package" && @zip@/bin/zip -rq0 "$nupkg" "$content")
            @stripNondeterminism@/bin/strip-nondeterminism --type zip "$nupkg"
            touch "$nupkg".sha512
        done
    )
}

createNugetSource() {
    local output
    for output in $(getAllOutputNames); do
        prefix="${!output}" _createNugetSourceInOutput
    done
}

if [[ -z ${dontCreateNugetSource-} ]]; then
    postFixupHooks+=(createNugetSource)
fi
