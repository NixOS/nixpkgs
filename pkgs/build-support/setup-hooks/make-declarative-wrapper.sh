preFixupPhases+=" makeDeclarativeWrapperPhase"

makeDeclarativeWrapperPhase() {
    runHook preMakeDeclarativeWrapper
    echo "Creating a declarative wrapper by evaluating: ${makeWrapperCalls}"
    export -f assertExecutable makeWrapper wrapProgram
    eval ${makeWrapperCalls}
    runHook postMakeDeclarativeWrapper
}
