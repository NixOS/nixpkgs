# Replace strange default value for the nobody account.
if test -n "@maxuid@"
then
  for f in util/faxadduser.c hfaxd/manifest.h
  do
    substituteInPlace "$f" --replace 60002 "@maxuid@"
  done
fi

# Replace hardcoded `PATH` variables with proper paths.
# Note: `findutils` is needed for `faxcron`.
substituteInPlace faxcover/edit-faxcover.sh.in \
  --replace 'PATH=/bin' 'PATH="@faxcover_binpath@"'
substituteInPlace etc/faxsetup.sh.in \
  --replace 'PATH=/bin' 'PATH="@faxsetup_binpath@"'

# Create `config.site`
substitute "@configSite@" config.site --subst-var out
