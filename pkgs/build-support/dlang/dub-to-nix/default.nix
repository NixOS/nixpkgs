{
  lib,
  writeShellScriptBin,
  coreutils,
  gnugrep,
  jq,
  nix,
}:

let
  binPath = lib.makeBinPath [
    coreutils
    gnugrep
    jq
    nix
  ];
in
writeShellScriptBin "dub-to-nix" ''
  set -euo pipefail

  PATH=${binPath}

  tmp=$(realpath "$(mktemp -td dub-to-nix.XXXXXX)")
  trap 'rm -r "$tmp"' EXIT

  if [ ! -f dub.selections.json ]; then
      echo 'The file `dub.selections.json` does not exist' >&2
      echo 'run `dub upgrade --annotate` to generate it' >&2
      exit 1
  fi

  # Create space separated "pname version" pair for each dependency
  deps=$(jq -r '.versions | to_entries[] | "\(.key) \(.value)"' dub.selections.json)

  IFS=$'\n'
  for dep in $deps; do
      IFS=" " read -r pname version <<< "$dep"
      if [[ $version == "~"* ]] ; then
          echo "Package \"$pname\" has a branch-type version \"$version\", which doesn't point to a fixed version" >&2
          echo 'You can resolve it by manually changing the required version to a fixed one inside `dub.selections.json`' >&2
          echo 'When packaging, you might need to create a patch for `dub.sdl` or `dub.json` to accept the changed version' >&2
          exit 1
      fi
  done

  echo "{ makeDubDep }:"
  echo "["

  for dep in $deps; do
      IFS=" " read -r pname version <<< "$dep"
      url="https://code.dlang.org/packages/$pname/$version.zip"
      if sha256=$(nix-prefetch-url --type sha256 "$url" 2> $tmp/error ); then
      echo "  (makeDubDep {"
      echo "    pname = \"$pname\";"
      echo "    version = \"$version\";"
      echo "    sha256 = \"$sha256\";"
      echo "  })"

      else
          echo "Failed to get hash from $url" >&2
          cat "$tmp/error" 1>&2
          exit 1
      fi
  done

  echo "]"
''
