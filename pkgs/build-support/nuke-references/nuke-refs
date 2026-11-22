#! @shell@

fixupHooks=()

if [[ -n "@signingUtils@" ]]; then
    source "@signingUtils@"
fi

excludes=""
while getopts e: o; do
    case "$o" in
        e) storeId=$(echo "$OPTARG" | @perl@/bin/perl -ne "print \"\$1\" if m|^\Q@storeDir@\E/([a-z0-9]{32})-.*|")
           if [ -z "$storeId" ]; then
               echo "-e argument must be a Nix store path"
               exit 1
           fi
           excludes="$excludes(?!$storeId)"
        ;;
    esac
done
shift $(($OPTIND-1))

for i in "$@"; do
    if test ! -L "$i" -a -f "$i"; then
        cat "$i" | @perl@/bin/perl -pe "s|\Q@storeDir@\E/$excludes[a-z0-9]{32}-|@storeDir@/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" > "$i.tmp"
        if test -x "$i"; then chmod +x "$i.tmp"; fi
        mv "$i.tmp" "$i"
        if [[ -n "@signingUtils@" ]]; then
            signIfRequired "$i"
        fi
    fi
done
