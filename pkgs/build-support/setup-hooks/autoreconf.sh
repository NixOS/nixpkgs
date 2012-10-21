preConfigurePhases+=" autoreconfPhase"

for i in @autoconf@ @automake@ @libtool@; do
    findInputs $i nativePkgs propagated-build-native-inputs
done

autoreconfPhase() {
    runHook preAutoreconf
    autoreconf ${autoreconfFlags:---install --force}
    runHook postAutoreconf
}
