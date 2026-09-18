#!@bash@

IFS=:

newLoadPath=()
newNativeLoadPath=()
addedNewLoadPath=
addedNewNativeLoadPath=

if [[ -n $EMACSLOADPATH ]]
then
    while read -rd: entry
    do
        if [[ -z $entry && -z $addedNewLoadPath ]]
        then
            newLoadPath+=(@wrapperSiteLisp@)
            addedNewLoadPath=1
        fi
        newLoadPath+=("$entry")
    done <<< "$EMACSLOADPATH:"
else
    newLoadPath+=(@wrapperSiteLisp@)
    newLoadPath+=("")
fi

# NOTE: Even though we treat EMACSNATIVELOADPATH like EMACSLOADPATH in
# this wrapper, empty elements in EMACSNATIVELOADPATH have no special
# meaning for Emacs.  Only non-empty elements in EMACSNATIVELOADPATH
# will be prepended to native-comp-eln-load-path.
# https://git.savannah.gnu.org/cgit/emacs.git/tree/lisp/startup.el?id=3685387e609753293c4518be75e77c659c3b2d8d#n599
if [[ -n $EMACSNATIVELOADPATH ]]
then
    while read -rd: entry
    do
        if [[ -z $entry && -z $addedNewNativeLoadPath ]]
        then
            newNativeLoadPath+=(@wrapperSiteLispNative@)
            addedNewNativeLoadPath=1
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

export emacsWithPackages_invocationDirectory=@wrapperInvocationDirectory@
export emacsWithPackages_invocationName=@wrapperInvocationName@

exec @prog@ "$@"
