#! @shell@

set -e
export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done
action="$1"

if ! test -e /etc/NIXOS; then
    echo "This is not a NixOS installation (/etc/NIXOS) is missing!"
    exit 1
fi

if test -z "$action"; then
    cat <<EOF
Usage: $0 [switch|boot|test]

switch: make the configuration the boot default and activate now
boot:   make the configuration the boot default
test:   activate the configuration, but don't make it the boot default
EOF
    exit 1
fi

if test "$action" = "switch" -o "$action" = "boot"; then
    if test -n "@grubDevice@"; then
        mkdir -m 0700 -p /boot/grub
        @grubMenuBuilder@ @out@
        if test "$NIXOS_INSTALL_GRUB" = 1; then
            @grub@/sbin/grub-install "@grubDevice@" --no-floppy --recheck
        fi
    else
        echo "Warning: don't know how to make this configuration bootable" 1>&2
    fi
fi

if test "$action" = "switch" -o "$action" = "test"; then
    echo "Activating the configuration..."
    @out@/activate
    kill -TERM 1 # make Upstart reload its events    
fi

sync
