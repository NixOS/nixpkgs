setFreeBSDSrcTop() {
  prependToVar makeFlags "SRCTOP=$BSDSRCDIR"
}

addFreeBSDMakeFlags() {
  prependToVar makeFlags "SBINDIR=${!outputBin}/bin"
  prependToVar makeFlags "LIBEXECDIR=${!outputLib}/libexec"
  prependToVar makeFlags "LIBDATADIR=${!outputLib}/data"
  prependToVar makeFlags "INCLUDEDIR=${!outputDev}/include"
  prependToVar makeFlags "CONFDIR=${!outputBin}/etc"
  prependToVar makeFlags "MANDIR=${!outputMan}/share/man/man"

  if [ -n "$debug" ]; then
    prependToVar makeFlags "DEBUGFILEDIR=${debug}/lib/debug"
  else
    prependToVar makeFlags "DEBUGFILEDIR=${out}/lib/debug"
  fi

  echoCmd 'FreeBSD makeFlags' "${makeFlags[@]}"
}

postUnpackHooks+=(setFreeBSDSrcTop)
preConfigureHooks+=(addFreeBSDMakeFlags)
