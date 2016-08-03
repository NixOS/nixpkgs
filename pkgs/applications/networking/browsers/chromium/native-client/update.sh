#!/bin/sh -e

usage() {
    >&2 cat << EOF
Usage: ./update.sh [rev] > sources.nix
where [rev] is the git revision of the native_client tree.

The script will use 'nix-prefetch-git' to get the native_client source tree,
along with its hash. It will then look at the 'pnacl/COMPONENT_REVISIONS' file
in this tree to figure out the revisions of the other git repositories it needs
to pull in, and prefetches those as well. The output of this script can be used
as a new 'sources.nix'.
EOF
}

prefetch() {
    local name=$1
    local git_url=$2
    local git_rev=$3
    local out_dir_var=$4

    local stdout=$(mktemp)
    local stderr=$(mktemp)

    # The output of nix-prefetch-git is in JSON format. The sed expression
    # below converts it into a nix-expression by:
    #   * adding a ; after the dictionary (s/}/};/)
    #   * replacing , after a dictionary entry with ; (s/,/;/)
    #   * replacing : in a dictionary entry with = (s/:/ =/)
    #   * adding a ; after the last dictionary entry (s/"$/";/)
    nix-prefetch-git $git_url $git_rev \
        2> $stderr \
        | grep -v date \
        | sed 's/}/};/;s/,/;/;s/:/ =/;s/"$/";/' \
        > $stdout

    echo "    $name = fetchgit"
    cat $stdout | sed 's/^/    /'

    if [ -n "$out_dir_var" ]
    then
        local out_dir=$(grep "path is " $stderr | sed 's/path is //')
        eval $out_dir_var="'$out_dir'"
    fi

    rm $stdout
    rm $stderr
}

if [ $# -ne 1 ]
then
    usage
    exit 1
fi

rev=$1
url=https://chromium.googlesource.com/native_client/src/native_client.git

echo "{ fetchgit"
echo "}:"
echo "rec {"
echo "  revision = \"$rev\";"
echo "  sources = {"

prefetch native_client $url $rev out

tail -n +2 repos | while read line
do
    url=$(echo $line | awk '{ print $1 }')
    typ=$(echo $line | awk '{ print $2 }')
    name=$(echo $line | awk '{ print $3 }')
    if [ "$typ" = "deps" ]
    then
        rev=$(cat $out/DEPS | grep "\"${name}_rev\":" | sed 's/[^:]\+: //;s/"//g;s/,//')
    else
        rev=$(cat $out/pnacl/COMPONENT_REVISIONS | grep "$name=" | sed 's/[^=]\+=//')
    fi

    prefetch $name $url $rev ""
done
echo "  };"

echo "  copySources = ''"
echo "    cp -prd \${sources.native_client} native_client"
echo "    chmod +wx native_client/toolchain_build"
echo "    mkdir native_client/toolchain_build/src"
echo

tail -n +2 repos | while read line
do
    typ=$(echo $line | awk '{ print $2 }')
    name=$(echo $line | awk '{ print $3 }')
    dir=$(echo $line | awk '{ print $4 }')
    if [ "$typ" = "deps" ]
    then
        echo "    ln -s \${sources.$name} $name"
    else
        echo "    cp -prd \${sources.$name} native_client/toolchain_build/src/$dir"
    fi
done

echo
echo "    chmod -R u+w native_client"
echo "    patchShebangs native_client"
echo
echo "    native_client/src/trusted/service_runtime/export_header.py \\"
echo "        native_client/src/trusted/service_runtime/include \\"
echo "        native_client/toolchain_build/src/pnacl-newlib/newlib/libc/sys/nacl"
echo
echo "    cp native_client/src/untrusted/pthread/pthread.h native_client/toolchain_build/src/pnacl-newlib/newlib/libc/include/"
echo "    cp native_client/src/untrusted/pthread/semaphore.h native_client/toolchain_build/src/pnacl-newlib/newlib/libc/include/"
echo "  '';"
echo "}"
