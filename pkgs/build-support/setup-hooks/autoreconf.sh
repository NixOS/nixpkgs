preConfigurePhases+=" autoreconfPhase"

for i in @autoconf@ @automake@ @libtool@ @gettext@; do
    findInputs $i nativePkgs propagated-native-build-inputs
done

autoreconfPhase() {
    runHook preAutoreconf
    autoreconf ${autoreconfFlags:---install --force --verbose}
    runHook postAutoreconf
}
