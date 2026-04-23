#!@execlineb@ -s0
pipeline -w { @sed@ -e "s|^gpg:OpenPGP:.*/bin/gpg$|gpg:OpenPGP:@out@/bin/gpg|" }
@gpgconf@ $@
