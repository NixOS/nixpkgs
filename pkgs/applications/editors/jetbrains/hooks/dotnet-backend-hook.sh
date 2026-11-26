#!@shell@

patchJetBrainsDotnet() {
    local backend="${jetbrainsDotnetBackend:?}" dir

    # See #590447. libmsalruntime.so depends on insecure
    # libwebkit2gtk-4.0.so.37 and libsoup-2.4.so.1. However, it is only
    # needed for Azure Artifacts authentication, which is only enabled on
    # Windows, as confirmed by .NET decompilation
    rm -f "$backend"/linux-*/libmsalruntime.so \
        "$backend"/runtimes/linux-*/native/libmsalruntime.so

    for dir in "$backend"/linux-*; do
        [[ -d "$dir" ]] || continue
        rm -rf "$dir/dotnet"
        ln -s "@dotnet@" "$dir/dotnet"
    done
}

preInstallHooks+=(patchJetBrainsDotnet)
