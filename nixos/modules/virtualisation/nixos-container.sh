#! @bash@/bin/sh -e

usage() {
    echo "Usage: $0 list" >&2
    echo "       $0 create <container-name> [--config <filename>] [--ensure-unique-name]" >&2
    echo "       $0 update <container-name>" >&2
    echo "       $0 destroy <container-name>" >&2
    echo "       $0 login <container-name>" >&2
    echo "       $0 root-shell <container-name>" >&2
    echo "       $0 set-root-password <container-name> <password>" >&2
    echo "       $0 show-ip <container-name>" >&2
}

args="`getopt --options '' -l help -l config: -l ensure-unique-name -- "$@"`"
eval "set -- $args"
extraConfigFile=
ensureUniqueName=
while [ $# -gt 0 ]; do
    case "$1" in
        (--help) usage; exit 0;;
        (--config) shift; extraConfigFile=$1;;
        (--ensure-unique-name) ensureUniqueName=1;;
        (--) shift; break;;
        (*) break;;
    esac
    shift
done

action="$1"
if [ -z "$action" ]; then usage; exit 1; fi
shift

getContainerRoot() {
    root="/var/lib/containers/$container"
    if ! [ -d "$root" ]; then
        echo "$0: container ‘$container’ does not exist" >&2
        exit 1
    fi
}

if [ $action = list ]; then
    for i in $(cd /etc/containers && echo *.conf); do
        echo "$(basename "$i" .conf)"
    done
    exit 0
fi

container="$1"
if [ -z "$container" ]; then usage; exit 1; fi
shift

if [ $action = create ]; then

    if [ -n "$ensureUniqueName" ]; then
        # FIXME: race
        nr=0
        while [ -e "/etc/containers/$container-$nr.conf" -o -e "/var/lib/containers/$container-$nr" ]; do
            : $((nr++))
        done
        container="$container-$nr"
    fi

    confFile="/etc/containers/$container.conf"
    root="/var/lib/containers/$container"

    if [ -e "$confFile" -o -e "$root/nix" ]; then
        echo "$0: container ‘$container’ already exists" >&2
        exit 1
    fi

    profileDir="/nix/var/nix/profiles/per-container/$container"
    mkdir -m 0755 -p "$root/etc/nixos" "$profileDir"

    config="
{ config, pkgs, ... }:

with pkgs.lib;

{ boot.isContainer = true;
  security.initialRootPassword = mkDefault \"!\";
  networking.hostName = mkDefault \"$container\";
  networking.useDHCP = false;
  imports = [ <nixpkgs/nixos/modules/virtualisation/container-login.nix> $extraConfigFile ];
  services.openssh.enable = true;
  services.openssh.extraConfig =
    ''
      UseDNS no
    '';
  users.extraUsers.root.openssh.authorizedKeys.keys = [ \"ssh-dss AAAAB3NzaC1kc3MAAACBAOo3foMFsYvc+LEVVTAeXpaxdOFG6O2NE9coxZYN6UtwE477GwkvZ4uKymAekq3TB8I6dDg4QFfE27fIip/rQHJ/Rus+KsxwnTbwPzE0WcZVpkKQsepsoqLkfwMpiPfn5/oxcnJsimwRY/E95aJmmOHdGaYWrc0t4ARa+6teUgdFAAAAFQCSQq2Wil0/X4hDypGGUKlKvYyaWQAAAIAy/0fSDnz1tZOQBGq7q78y406HfWghErrVlrW9g+foJQG5pgXXcdJs9JCIrlaKivUKITDsYnQaCjrZaK8eHnc4ksbkSLfDOxFnR5814ulCftrgEDOv9K1UU3pYketjFMvQCA2U48lR6jG/99CPNXPH55QEFs8H97cIsdLQw9wM4gAAAIEAmzWZlXLzIf3eiHQggXqvw3+C19QvxQITcYHYVTx/XYqZi1VZ/fkY8bNmdcJsWFyOHgEhpEca+xM/SNvH/14rXDmt0wtclLEx/4GVLi59hQCnnKqv7HzJg8RF4v6XTiROBAEEdb4TaFuFn+JCvqPzilTzXTexvZKJECOvfYcY+10= eelco.dolstra@logicblox.com\" ];
}"
    configFile="$root/etc/nixos/configuration.nix"
    echo "$config" > "$configFile"

    nix-env -p "$profileDir/system" -I "nixos-config=$configFile" -f '<nixpkgs/nixos>' --set -A system

    # Allocate a new /8 network in the 10.233.* range.  FIXME: race
    network="$(sed -e 's/.*_ADDRESS=10\.233\.\(.*\)\..*/\1/; t; d' /etc/containers/*.conf | sort -n | tail -n1)"
    if [ -z "$network" ]; then network=0; else : $((network++)); fi

    hostAddress="10.233.$network.1"
    localAddress="10.233.$network.2"
    echo "host IP is $hostAddress, container IP is $localAddress" >&2

    cat > "$confFile" <<EOF
PRIVATE_NETWORK=1
HOST_ADDRESS=$hostAddress
LOCAL_ADDRESS=$localAddress
EOF

    echo "starting container@$container.service..." >&2
    systemctl start "container@$container.service"

    # Print generated container name on stdout.
    if [ -n "$ensureUniqueName" ]; then
        echo "$container"
    fi

elif [ $action = update ]; then

    getContainerRoot

    configFile="$root/etc/nixos/configuration.nix"
    profileDir="/nix/var/nix/profiles/per-container/$container"

    nix-env -p "$profileDir/system" -I "nixos-config=$configFile" -f '<nixpkgs/nixos>' --set -A system

    echo "reloading container@$container.service..." >&2
    systemctl reload "container@$container.service"

elif [ $action = destroy ]; then

    getContainerRoot

    confFile="/etc/containers/$container.conf"
    if [ -e "$confFile" -a ! -w "$confFile" ]; then
        echo "$0: cannot destroy declarative container (remove it from your configuration.nix instead)"
        exit 1
    fi

    if systemctl show "container@$container.service" | grep -q ActiveState=active; then
        echo "stopping container@$container.service..." >&2
        systemctl stop "container@$container.service"
    fi

    rm -f "$confFile"
    rm -rf "$root"

elif [ $action = login ]; then

    getContainerRoot
    exec @socat@/bin/socat "unix:$root/var/lib/login.socket" -,echo=0,raw

elif [ $action = root-shell ]; then

    getContainerRoot
    exec @socat@/bin/socat "unix:$root/var/lib/root-shell.socket" -

elif [ $action = set-root-password ]; then

    password="$1"
    if [ -z "$password" ]; then usage; exit 1; fi

    # FIXME: not very secure.
    getContainerRoot
    (echo "passwd"; echo "$password"; echo "$password") | @socat@/bin/socat "unix:$root/var/lib/root-shell.socket" -

elif [ $action = show-ip ]; then

    getContainerRoot
    . "/etc/containers/$container.conf"
    echo "$LOCAL_ADDRESS"

else
    echo "$0: unknown action ‘$action’" >&2
    exit 1
fi
