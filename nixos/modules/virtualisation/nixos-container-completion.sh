#!/usr/bin/env bash

_nixos-container() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="list create destroy start stop status update login root-login run show-ip show-host-key"
    startstop_opts=$(nixos-container list)
    update_opts="--config"

    if [[ "$prev" == "nixos-container" ]]
    then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

    if [[ $(echo "$opts" | grep "$prev") ]]
    then
        if [[ "$prev" == "start" || "$prev" == "stop" ]]
        then
            COMPREPLY=( $(compgen -W "${startstop_opts}" -- ${cur}) )
            return 0
        elif [[ "$prev" == "update" ]]
        then
            COMPREPLY=( $(compgen -W "${update_opts}" -- ${cur}) )
            return 0
        fi
    fi
}

complete -F _nixos-container nixos-container

