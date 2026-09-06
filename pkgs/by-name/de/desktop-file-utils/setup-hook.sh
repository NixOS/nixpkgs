# Remove mimeinfo cache
mimeinfoPreFixupPhase() {
    rm -f $out/share/applications/mimeinfo.cache
}

appendToVar preFixupPhases mimeinfoPreFixupPhase
