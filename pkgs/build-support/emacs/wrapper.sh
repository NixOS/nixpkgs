#!@bash@

IFS=:

newLoadPath=()
added=

if [[ -n $EMACSLOADPATH ]]
then
    while read -rd: entry
    do
        if [[ -z $entry && -z $added ]]
        then
            newLoadPath+=(@wrapperSiteLisp@)
            added=1
        fi
        newLoadPath+=("$entry")
    done <<< "$EMACSLOADPATH:"
else
    newLoadPath+=(@wrapperSiteLisp@)
    newLoadPath+=("")
fi

export EMACSLOADPATH="${newLoadPath[*]}"

exec @prog@ "$@"
