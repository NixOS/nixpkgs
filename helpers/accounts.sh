userExists() {
    local name="$1"
    if id -u "$name" > /dev/null 2>&1; then
        return 0 # true
    else
        return 1 # false
    fi
}


createUser() {
    local name="$1"
    local password="$2"
    local uid="$3"
    local gid="$4"
    local gecos="$5"
    local homedir="$6"
    local shell="$7"
    echo "$name:$password:$uid:$gid:$gecos:$homedir:$shell" >> /etc/passwd
}
