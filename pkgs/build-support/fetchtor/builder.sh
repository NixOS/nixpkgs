torSocket=$NIX_BUILD_TOP/.tor.sock
torPort=unix:$torSocket

exec {tor_fd}< <(tor --DataDirectory "$NIX_BUILD_TOP/.tor" --SocksPort "$torPort")
trap "kill '$!'" EXIT

# Wait for Tor to start
read < <(<&$tor_fd- tee /dev/fd/2 | grep -m 1 -F 'Bootstrapped 100% (done): Done')

export ALL_PROXY="socks5h://localhost$torSocket"
export http_proxy=$ALL_PROXY # fetchgit insists on this variable even though Git does not
export NO_PROXY=${noTor// /,}

. "$innerBuilder"
