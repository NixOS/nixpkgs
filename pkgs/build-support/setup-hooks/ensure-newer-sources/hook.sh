postUnpackHooks+=(_ensureNewerSources)
_ensureNewerSources() {
  local r=$sourceRoot

  # Avoid passing option-looking directory to find. The example is diffoscope-269:
  #   https://salsa.debian.org/reproducible-builds/diffoscope/-/issues/378
  [[ $r == -* ]] && r="./$r"
  "@find" "$r" '!' -newermt '@year@-01-01' -exec touch -h -d '@year@-01-02' '{}' '+'
}
