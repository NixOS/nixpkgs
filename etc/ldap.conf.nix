{writeText, config}:

# Careful: OpenLDAP seems to be very picky about the indentation of
# this file.  Directives HAVE to start in the first column!

writeText "ldap.conf" "

uri ${config.users.ldap.server}
base ${config.users.ldap.base}
  
${
if config.users.ldap.useTLS then "
ssl start_tls
tls_checkpeer no
" else ""
}

"
