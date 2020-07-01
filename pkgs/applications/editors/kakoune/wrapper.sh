#!@bash@/bin/bash

# We use the -E option to load plugins.  This only makes sense when we are
# starting a new session, so we detect that.  Also, Kakoune can only handle
# one -E option, so we prepend loading plugins to an existing one.
args=( "$@" )
loadPlugins=true
EValueOffset=-1
pluginScript='@out@/share/kak/plugins.kak'

for (( i = 0; i < ${#args[@]}; i++ )); do
    case "${args[i]}" in
        -n|-c|-l|-p|-clear|-version) loadPlugins=false;;
        -E)                          EValueOffset=$(( i + 1 ));;
        --)                          break;;
    esac
    case "${args[i]}" in
        -E|-c|-e|-s|-p|-f|-i|-ui|-debug) i=$(( i + 1 ));;
    esac
done

if [[ $loadPlugins = true ]]; then
    if (( EValueOffset >= 0 )); then
        args[EValueOffset]="source '$pluginScript'"$'\n'"${args[EValueOffset]}"
    else
        args=( "-E" "source '$pluginScript'" "${args[@]}" )
    fi
fi

exec @kakoune@/bin/kak "${args[@]}"
