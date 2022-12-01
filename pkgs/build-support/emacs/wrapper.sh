#!@bash@

IFS=:

newLoadPath=()
newNativeLoadPath=()
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

if [[ -n $EMACSNATIVELOADPATH ]]
then
    while read -rd: entry
    do
        if [[ -z $entry && -z $added ]]
        then
            newNativeLoadPath+=(@wrapperSiteLispNative@)
            added=1
        fi
        newNativeLoadPath+=("$entry")
    done <<< "$EMACSNATIVELOADPATH:"
else
    newNativeLoadPath+=(@wrapperSiteLispNative@)
    newNativeLoadPath+=("")
fi

export EMACSLOADPATH="${newLoadPath[*]}"
export emacsWithPackages_siteLisp=@wrapperSiteLisp@

export EMACSNATIVELOADPATH="${newNativeLoadPath[*]}"
export emacsWithPackages_siteLispNative=@wrapperSiteLispNative@

exec @prog@ "$@"
