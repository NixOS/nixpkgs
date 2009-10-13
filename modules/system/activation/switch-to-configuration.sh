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
    if [ "@bootLoader@" == "grub" ]; then
      if test -n "@grubDevice@"; then
          mkdir -m 0700 -p /boot/grub
          @menuBuilder@ @out@
          if test "$NIXOS_INSTALL_GRUB" = 1; then
	      echo "running \`@grub@/sbin/grub-install'..."
              @grub@/sbin/grub-install "@grubDevice@" --no-floppy --recheck
          fi
      else
          echo "Warning: don't know how to make this configuration bootable; please set \`boot.grubDevice'." 1>&2
      fi
    elif [ "@bootLoader@" == "generationsDir" ]; then
          @menuBuilder@ @out@
    else
          echo "Warning: don't know how to make this configuration bootable; please enable a boot loader." 1>&2
    fi
fi

if test "$action" = "switch" -o "$action" = "test"; then

    oldVersion=$(cat /var/run/current-system/upstart-interface-version 2> /dev/null || echo 0)
    newVersion=$(cat @out@/upstart-interface-version 2> /dev/null || echo 0)

    if test "$oldVersion" -ne "$newVersion"; then
        cat <<EOF
Warning: the new NixOS configuration has an Upstart version that is
incompatible with the current version.  The new configuration won't
take effect until you reboot the system.
EOF
        exit 1
    fi

    oldEvents=$(readlink -f /etc/event.d || true)
    newEvents=$(readlink -f @out@/etc/event.d)

    #echo "old: $oldEvents"
    #echo "new: $newEvents"

    stopJob() {
        local job=$1
        initctl stop "$job"
        while ! initctl status "$job" 2>&1 | grep -q "(stop) waiting"; do
            echo "waiting for $job to stop..."
            sleep 1
        done
    }

    # Stop all services that are not in the new Upstart
    # configuration.
    for event in $(cd $oldEvents && ls); do
        if ! test -e "$newEvents/$event"; then
            echo "stopping $event..."
            stopJob $event
        fi
    done

    # Activate the new configuration (i.e., update /etc, make
    # accounts, and so on).
    echo "activating the configuration..."
    @out@/activate @out@

    # Make Upstart reload its events.  !!! Should wait until it has
    # finished processing its stop events.
    kill -TERM 1 

    # Start all new services and restart all changed services.
    for event in $(cd $newEvents && ls); do

        # Hack: skip the sys-* and ctrl-alt-delete events.
        # Another hack: don't restart the X server (that would kill all the clients).
        # And don't restart dbus, since that causes ConsoleKit to
        # forget about current sessions.
        if echo "$event" | grep -q "^sys-\|^ctrl-\|^xserver$\|^dbus$"; then continue; fi
    
        if ! test -e "$oldEvents/$event"; then
            echo "starting $event..."
            initctl start "$event"
        elif test "$(readlink "$oldEvents/$event")" != "$(readlink "$newEvents/$event")"; then
            echo "restarting $event..."
            stopJob $event
            initctl start "$event"
        fi
    done
fi
