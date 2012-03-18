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
        
      if [ -n "@grubDevices@" ]; then
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
          
      else
          echo "Warning: don't know how to make this configuration bootable; please set \`boot.loader.grub.device'." 1>&2
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

newJobs=$(readlink -f @out@/etc/init)

# Stop all currently running jobs that are not in the new Upstart
# configuration.  (Here "running" means all jobs that are not in the
# stop/waiting state.)
for job in $(initctl list | sed -e '/ stop\/waiting/ d; /^[^a-z]/ d; s/^\([^ ]\+\).*/\1/' | sort); do
    if ! [ -e "$newJobs/$job.conf" ] ; then
        echo "stopping obsolete job ‘$job’..."
        initctl stop "$job" || true
    fi
done

# Activate the new configuration (i.e., update /etc, make accounts,
# and so on).
echo "activating the configuration..."
@out@/activate @out@

# Make Upstart reload its jobs.
initctl reload-configuration

# Allow Upstart jobs to react intelligently to a config change.
initctl emit config-changed

# Restart all running jobs that have changed.  (Here "running" means
# all jobs that don't have a "stop" goal.)  We use the symlinks in
# /var/run/upstart-jobs (created by each job's pre-start script) to
# determine if a job has changed.
for job in $(cd $newJobs && ls *.conf); do
    job=$(basename $job .conf)
    status=$(status "$job")
    if ! [[ "$status" =~ start/ ]]; then continue; fi
    if [ "$(readlink -f "$newJobs/$job.conf")" = "$(readlink -f "/var/run/upstart-jobs/$job")" ]; then continue; fi
    if ! grep -q "^# RESTART-IF-CHANGED" "$newJobs/$job.conf"; then
        echo "not restarting changed service ‘$job’"
        continue
    fi
    echo "restarting changed service ‘$job’..."
    # Note: can't use "restart" here, since that only restarts the
    # job's main process.
    stop "$job" || true
    start "$job" || true
done

# Start all jobs that are not running but should be.  The "should be"
# criterion is tricky: the intended semantics is that we end up with
# the same jobs as after a reboot.  If it's a task, restart it if it
# differs from the previous instance of the same task; if it wasn't
# previously run, don't run it.  If it's a service, only start it if
# it has a "start on" condition.
for job in $(cd $newJobs && ls *.conf); do
    job=$(basename $job .conf)
    status=$(status "$job")
    if ! [[ "$status" =~ stop/ ]]; then continue; fi

    if grep -q '^task$' "$newJobs/$job.conf"; then
        if [ ! -e "/var/run/upstart-jobs/$job" -o \
            "$(readlink -f "$newJobs/$job.conf")" = "$(readlink -f "/var/run/upstart-jobs/$job")" ];
        then continue; fi
        echo "starting task ‘$job’..."
        start "$job" || true
    else
        if ! grep -q "^start on" "$newJobs/$job.conf"; then continue; fi
        echo "starting service ‘$job’..."
        start "$job" || true
    fi
    
done

# Signal dbus to reload its configuration.
dbusPid=$(initctl status dbus 2> /dev/null | sed -e 's/.*process \([0-9]\+\)/\1/;t;d')
[ -n "$dbusPid" ] && kill -HUP "$dbusPid"
