{ writeScript, runtimeShell }:

writeScript "update-mendeley" ''
  #!${runtimeShell}
  function follow() {
    local URL=$1
    while true; do
      NEWURL=$(curl -m20 -sI "$URL" -o /dev/null -w '%{redirect_url}')
      [ -z "$NEWURL" ] && break
      [[ $NEWURL = $URL ]] && (echo "redirect loop?!"; exit 1)
      echo "Following $URL -> $NEWURL ..." >&2
      URL=$NEWURL
    done

    echo $URL
  }

  amd64URL=$(follow https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest)
  amd64V=$(basename $amd64URL|grep -m1 -o "[0-9]\+\.[0-9]\+\(\.[0-9]\+\)\?")
  i386URL=$(follow https://www.mendeley.com/repositories/ubuntu/stable/i386/mendeleydesktop-latest)
  i386V=$(basename $i386URL|grep -m1 -o "[0-9]\+\.[0-9]\+\(\.[0-9]\+\)\?")

  echo "amd64 version: $amd64V"
  echo "i386 version:  $i386V"
  if [[ $amd64V != $i386V ]]; then
    echo "Versions not the same!"
    exit 1
  fi

  if grep -q -F "$amd64V" ${./default.nix}; then
    echo "No new version yet, nothing to do."
    echo "Have a nice day!"
    exit 0
  fi

  amd64OldHash=$(nix-instantiate --eval --strict -A "mendeley.src.drvAttrs.outputHash" --argstr system "x86_64-linux"| tr -d '"')
  i386OldHash=$(nix-instantiate --eval --strict -A "mendeley.src.drvAttrs.outputHash" --argstr system "i686-linux"| tr -d '"')

  echo "Prefetching amd64..."
  amd64NewHash=$(nix-prefetch-url $amd64URL)
  echo "Prefetching i386..."
  i386NewHash=$(nix-prefetch-url $i386URL)

  # Don't actually update, just report that an update is available
  cat <<EOF


  Time to update to $amd64V !

  32bit (i386):
    Old: $i386OldHash
    New: $i386NewHash
  64bit (amd64):
    Old: $amd64OldHash
    New: $amd64NewHash

  Exiting so this information is seen...
  (no update is actually performed here)
  EOF
  exit 1
''
