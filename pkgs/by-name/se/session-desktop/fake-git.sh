if [ "$1" != "rev-parse" ]; then
  echo "$@" >&2
  exit 1
fi
shift

short=0
shortlen=7
ref=
while [ $# -gt 0 ]; do
  case "$1" in
    --short)
      short=1
      if [ $# -gt 1 ] && [ "$2" -eq "$2" ] 2>/dev/null; then
        shortlen=$2
        shift
      else
        shortlen=7
      fi
      ;;
    --short=*)
      short=1
      shortlen=''${1#--short=}
      ;;
    --is-inside-work-tree)
      echo true
      exit 0
      ;;
    HEAD|HEAD:*)
      ref=$1
      ;;
    *)
      echo "rev-parse $@" >&2
      exit 1
      ;;
  esac
  shift
done

if [ -z "$ref" ]; then
  echo "rev-parse" >&2
  exit 1
fi

case "$ref" in
  HEAD)
    path=$(pwd)
    hash=
    while [ "$path" != "/" ]; do
      if [ -f "$path/.gitrev" ]; then
        hash=$(cat "$path/.gitrev")
        break
      fi
      path=$(dirname "$path")
    done
    ;;
  HEAD:*)
    subpath=''${ref#HEAD:}
    if [ -f "$PWD/$subpath/.gitrev" ]; then
      hash=$(cat "$PWD/$subpath/.gitrev")
    fi
    ;;
esac

if [ -z "$hash" ]; then
  echo "rev-parse $ref" >&2
  exit 1
fi

if [ "$short" -eq 1 ]; then
  printf '%s\n' "$(printf '%s' "$hash" | cut -c1-"$shortlen")"
else
  printf '%s\n' "$hash"
fi
