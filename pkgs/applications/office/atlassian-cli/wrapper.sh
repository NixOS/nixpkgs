#!/bin/bash

tool=@tool@
user=ATLASSIAN_${tool^^}_USER
host=ATLASSIAN_${tool^^}_HOST
pass=ATLASSIAN_${tool^^}_PASS

[ -f ~/.atlassian-cli ] && source ~/.atlassian-cli
if [ x = ${!user-x} ] || [ x = ${!host-x} ] || [ x = ${!pass-x} ]
then
    >&2 echo please define $user, $host, and $pass in '~/.atlassian-cli'
    exit 1
fi

@jre@/bin/java \
    -jar @out@/share/java/@tool@-cli-* \
    --server "${!host}" \
    --user "${!user}" \
    --password "${!pass}" \
    "$@"
