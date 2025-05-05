breakpointHook() {
    local red='\033[0;31m'
    local cyan='\033[0;36m'
    local green='\033[0;32m'
    local no_color='\033[0m'

    # provide the user with an interactive shell for better experience
    export bashInteractive="@bashInteractive@"
    dumpVars

    local id
    id="$(shuf -i 999999-9999999 -n1)"
    echo -e "${red}build for ${cyan}${name:-unknown}${red} failed in ${curPhase:-unknown} with exit code ${exitCode:-unknown}${no_color}"
    echo -e "${green}To attach, run the following command:${no_color}"
    echo -e "${green}    sudo @attach@ $id${no_color}"
    sleep "$id"
}
failureHooks+=(breakpointHook)
