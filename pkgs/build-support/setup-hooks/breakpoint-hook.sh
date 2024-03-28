breakpointHook() {
    local red='\033[0;31m'
    local no_color='\033[0m'

    echo -e "${red}build failed in ${curPhase} with exit code ${exitCode}${no_color}"
    printf "To attach install cntr and run the following command as root:\n\n"
    echo "   cntr attach -t command cntr-${out}"
    echo 'See more info on cntr at https://github.com/Mic92/cntr#usage'
    sh -c "while true; do sleep 99999999; done"
}
failureHooks+=(breakpointHook)
