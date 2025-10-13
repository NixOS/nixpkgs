echo "exporting $url (r$rev) into $out"

if test -n "$http_proxy"; then
    # Configure proxy
    mkdir .subversion
    proxy="${http_proxy#*://}"

    echo '[global]' > .subversion/servers
    echo "http-proxy-host = ${proxy%:*}" >> .subversion/servers
    echo "http-proxy-port = ${proxy##*:}" >> .subversion/servers

    export HOME="$PWD"
fi;

if test -z "$LC_ALL"; then
    export LC_ALL="en_US.UTF-8"
fi;

svn export --trust-server-cert --non-interactive \
    ${ignoreExternals:+--ignore-externals} ${ignoreKeywords:+--ignore-keywords} \
    -r "$rev" "$url" "$out"
