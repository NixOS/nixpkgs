# Set up the initial path.
for i in @INITIALPATH@; do
    PATH=$PATH:$i/bin
done
echo $PATH

# Execute the pre-hook.
param1=@PARAM1@
param2=@PARAM2@
param3=@PARAM3@
param4=@PARAM4@
param5=@PARAM5@
. @PREHOOK@

# Add the directory containing the GCC wrappers to the PATH.
export PATH=@OUT@/bin:$PATH

# Recursively add all buildinputs to the relevant environment variables.
addtoenv()
{
    pkgs="$buildinputs $1"

    if test -d $1/bin; then
        export PATH=$1/bin:$PATH
    fi

    if test -d $1/lib; then
        export NIX_CFLAGS_LINK="-L$1/lib $NIX_CFLAGS_LINK"
        export NIX_LDFLAGS="-rpath $1/lib $NIX_LDFLAGS"
    fi

    if test -d $1/lib/pkgconfig; then
        export PKG_CONFIG_PATH=$1/lib/pkgconfig:$PKG_CONFIG_PATH
    fi

    if test -d $1/include; then
        export NIX_CFLAGS_COMPILE="-I$1/include $NIX_CFLAGS_COMPILE"
    fi

    if test -f $1/propagated-build-inputs; then
        for i in $(cat $1/propagated-build-inputs); do
            addtoenv $i
        done
    fi
}

oldbuildinputs=$buildinputs
buildinputs=

for i in $oldbuildinputs; do
    addtoenv $i
done

# Add the output as an rpath.
if test "$NIX_NO_SELF_RPATH" != "1"; then
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
fi

# Strip debug information by default.
export NIX_STRIP_DEBUG=1

# Execute the post-hook.
. @POSTHOOK@

if test "$NIX_DEBUG" == "1"; then
    echo "Setup: PATH=$PATH"
fi
