#!@bash@

IFS=:

newLoadPath=()
newNativeLoadPath=()
<<<<<<< HEAD
addedNewLoadPath=
addedNewNativeLoadPath=
=======
added=
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

if [[ -n $EMACSLOADPATH ]]
then
    while read -rd: entry
    do
<<<<<<< HEAD
        if [[ -z $entry && -z $addedNewLoadPath ]]
        then
            newLoadPath+=(@wrapperSiteLisp@)
            addedNewLoadPath=1
=======
        if [[ -z $entry && -z $added ]]
        then
            newLoadPath+=(@wrapperSiteLisp@)
            added=1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        fi
        newLoadPath+=("$entry")
    done <<< "$EMACSLOADPATH:"
else
    newLoadPath+=(@wrapperSiteLisp@)
    newLoadPath+=("")
fi

<<<<<<< HEAD
# NOTE: Even though we treat EMACSNATIVELOADPATH like EMACSLOADPATH in
# this wrapper, empty elements in EMACSNATIVELOADPATH have no special
# meaning for Emacs.  Only non-empty elements in EMACSNATIVELOADPATH
# will be prepended to native-comp-eln-load-path.
# https://git.savannah.gnu.org/cgit/emacs.git/tree/lisp/startup.el?id=3685387e609753293c4518be75e77c659c3b2d8d#n599
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
if [[ -n $EMACSNATIVELOADPATH ]]
then
    while read -rd: entry
    do
<<<<<<< HEAD
        if [[ -z $entry && -z $addedNewNativeLoadPath ]]
        then
            newNativeLoadPath+=(@wrapperSiteLispNative@)
            addedNewNativeLoadPath=1
=======
        if [[ -z $entry && -z $added ]]
        then
            newNativeLoadPath+=(@wrapperSiteLispNative@)
            added=1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
