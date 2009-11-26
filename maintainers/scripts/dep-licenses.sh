#!/bin/sh

attr=$1

: ${NIXPKGS=/etc/nixos/nixpkgs}

tmp=$(mktemp --tmpdir -d nixpkgs-dep-license.XXXXXX)

exitHandler() {
    exitCode=$?
    rm -rf "$tmp"
    exit $exitCode
}

trap "exitHandler" EXIT

# fetch the trace and the drvPath of the attribute.
nix-instantiate $NIXPKGS -A $attr --show-trace > "$tmp/drvPath" 2> "$tmp/trace" || {
  cat 1>&2 - "$tmp/trace" <<EOF
An error occured while evaluating $attr.
EOF
  exit 1
}

# generate a sed script based on the trace output.
sed '
  \,@:.*:@, {
    # \1  *.drv file
    # \2  License terms
    s,.*@:drv:\(.*\):\(.*\):@.*,s!\1!\1: \2!; t;,
    s!Str(\\\"\([^,]*\)\\\",\[\])!\1!g
    b
  }
  d
' "$tmp/trace" > "$tmp/filter.sed"

if test $(wc -l "$tmp/filter.sed" | sed 's/ .*//') == 0; then
  echo 1>&2 "
No derivation mentionned in the stack trace.  Either your derivation does
not use stdenv.mkDerivation or you forgot to use the stdenv adapter named
traceDrvLicenses.

-  defaultStdenv = allStdenvs.stdenv;
+  defaultStdenv = traceDrvLicenses allStdenvs.stdenv;
"
  exit 1
fi


# remove all dependencies which are using stdenv.mkDerivation
echo '
d
' >> "$tmp/filter.sed"

nix-store -q --tree $(cat "$tmp/drvPath") | sed -f "$tmp/filter.sed"

exit 0;
