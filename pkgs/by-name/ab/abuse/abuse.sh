#! @shell@

if grep datadir ~/.abuse/abuserc &>/dev/null; then
  if [ ! -d "$(grep datadir ~/.abuse/abuserc | cut -d= -f2)" ]; then
    echo "Warning: ~/.abuse/abuserc references a datadir which is not existent." >&2
    echo "Try removing ~/.abuse/abuserc, else abuse will most likely not run." >&2
    echo >&2
    # This can happen if the build hash of abuse changes and the older version
    # is garbage-collected. The correct path of the datadir is compiled into
    # the binary, but unfortunately abuse writes out the path into abuserc on
    # first start. This entry may later become stale.
  fi
fi

# The timidity bundled into SDL_mixer looks in . and in several global places
# like /etc for its configuration file.
cd @out@/etc
exec @out@/bin/.abuse-bin "$@"
