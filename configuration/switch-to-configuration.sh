#! @shell@

set -e
export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin:$i/sbin; done
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

    oldEvents=$(readlink -f /etc/event.d || true)
    newEvents=$(readlink -f @out@/etc/event.d)

    echo "old: $oldEvents"
    echo "new: $newEvents"

    # Stop all services that are not in the new Upstart
    # configuration.
    for event in $(cd $oldEvents && ls); do
        if ! test -e "$newEvents/$event"; then
            echo "stopping $event..."
            initctl stop "$event"
        fi
    done

    # Activate the new configuration (i.e., update /etc, make
    # accounts, and so on).
    echo "Activating the configuration..."
    @out@/activate

    # Make Upstart reload its events.  !!! Should wait until it has
    # finished processing its stop events.
    kill -TERM 1 

    # Start all new services and restart all changed services.
    for event in $(cd $newEvents && ls); do
        if ! test -e "$oldEvents/$event"; then
            echo "starting $event..."
            initctl start "$event"
        elif test "$(readlink "$oldEvents/$event")" != "$(readlink "$newEvents/$event")"; then
            echo "restarting $event..."
            initctl stop "$event"
            initctl start "$event"
        else
            echo "unchanged $event"
        fi
    done
fi

sync
