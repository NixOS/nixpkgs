# Parts of the `install` make target don't
# dare to set file modes (or owners), but put the
# needed commands in a new file called `root.sh`.
# We execute the `chmod` commands of
# this script to set execute bits.
sed '/chown/d;/chgrp/d' --in-place root.sh
. root.sh

# We run `faxsetup` to prepare some config files
# that the admin would have to create otherwise.
# Since `faxsetup` is quite picky about its environment,
# we have to prepare some dummy files.
# `faxsetup` stores today's date in the output files,
# so we employ faketime to simulate a deterministic date.
echo "uucp:x:0" >> "$TMPDIR/passwd.dummy"  # dummy uucp user
touch "$out/spool/etc/config.dummy"  # dummy modem config
mkdir "$TMPDIR/lock.dummy"  # dummy lock dir
"@libfaketime@/bin/faketime" -f "$(date --utc --date=@$SOURCE_DATE_EPOCH '+%F %T')" \
  "@fakeroot@/bin/fakeroot" -- \
  "$out/spool/bin/faxsetup" -with-DIR_LOCKS="$TMPDIR/lock.dummy" -with-PASSWD="$TMPDIR/passwd.dummy"
rm "$out/spool/etc/config.dummy"

# Ensure all binaries are reachable within the spooling area.
ln --symbolic --target-directory="$out/spool/bin/" "$out/bin/"*
