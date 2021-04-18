{ writeShellScriptBin, patchelf }:

writeShellScriptBin "find-libs" ''
  set -euo pipefail

  declare -A seen
  declare -a left

  patchelf="${patchelf}/bin/patchelf"

  function add_needed {
    rpath="$($patchelf --print-rpath $1)"
    dir="$(dirname $1)"
    for lib in $($patchelf --print-needed $1); do
      left+=("$lib" "$rpath" "$dir")
    done
  }

  add_needed $1

  while [ ''${#left[@]} -ne 0 ]; do
    next=''${left[0]}
    rpath=''${left[1]}
    ORIGIN=''${left[2]}
    left=("''${left[@]:3}")
    if [ -z ''${seen[$next]+x} ]; then
      seen[$next]=1

      IFS=: read -ra paths <<< $rpath
      res=
      for path in "''${paths[@]}" $ORIGIN; do
        path=$(eval "echo $path")
        if [ -f "$path/$next" ]; then
            res="$path/$next"
            echo "$res"
            add_needed "$res"
            break
        fi
      done
      if [ -z "$res" ]; then
        echo "Couldn't satisfy dependency $next" >&2
        exit 1
      fi
    fi
  done
''
