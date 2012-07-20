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

# Install or update the bootloader.
if [ "$action" = "switch" -o "$action" = "boot" ]; then
    
    if [ "@bootLoader@" = "grub" ]; then
        
        mkdir -m 0700 -p /boot/grub
        @menuBuilder@ @out@

        # If the GRUB version has changed, then force a reinstall.
        oldGrubVersion="$(cat /boot/grub/version 2>/dev/null || true)"
        newGrubVersion="@grubVersion@"

        if [ "$NIXOS_INSTALL_GRUB" = 1 -o "$oldGrubVersion" != "$newGrubVersion" ]; then
            for dev in @grubDevices@; do
                if [ "$dev" != nodev ]; then
                    echo "installing the GRUB bootloader on $dev..."
                    @grub@/sbin/grub-install "$(readlink -f "$dev")" --no-floppy
                fi
            done
            echo "$newGrubVersion" > /boot/grub/version
        fi
          
    elif [ "@bootLoader@" = "generationsDir" ]; then
        @menuBuilder@ @out@
    elif [ "@bootLoader@" = "efiBootStub" ]; then
        @menuBuilder@ @out@
    else
        echo "Warning: don't know how to make this configuration bootable; please enable a boot loader." 1>&2
    fi

    if [ -n "@initScriptBuilder@" ]; then
        @initScriptBuilder@ @out@
    fi
fi

# Activate the new configuration.
if [ "$action" != switch -a "$action" != test ]; then exit 0; fi

oldVersion="$(cat /run/current-system/init-interface-version 2> /dev/null || echo "")"
newVersion="$(cat @out@/init-interface-version)"

if [ "$oldVersion" != "$newVersion" ]; then
        cat <<EOF
Warning: the new NixOS configuration has an ‘init’ that is
incompatible with the current configuration.  The new configuration
won't take effect until you reboot the system.
EOF
        exit 100 # denotes "reboot required" to Charon
fi

# Ignore SIGHUP so that we're not killed if we're running on (say)
# virtual console 1 and we restart the "tty1" job.
trap "" SIGHUP

# Activate the new configuration (i.e., update /etc, make accounts,
# and so on).
echo "activating the configuration..."
@out@/activate @out@

# FIXME: Re-exec systemd if necessary.

# Make systemd reload its jobs.
systemctl daemon-reload

# Signal dbus to reload its configuration.
systemctl reload dbus.service || true
