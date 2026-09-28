unpackCmdHooks+=(_try7zip)
unpackCmdHooks+=(_tryUnpackDmg)

_try7zip() {
  if ! [[ $curSrc =~ \.7z$ ]]; then return 1; fi
  7z x -snld "$curSrc"
}

_tryUnpackDmg() {
  if ! [[ $curSrc =~ \.dmg$ ]]; then return 1; fi
  7z x -sns- -snld "$curSrc"
}
