#! /bin/sh

own_dir="$(cd "$(dirname "$0")"; pwd)"

CURRENT_URL=

url () {
  CURRENT_URL="$1"
}

version_unpack () {
  sed -re '
    s/[.]/ /g; 
    s@/@ / @g
    s/-(rc|pre)/ -1 \1 /g; 
    s/-(gamma)/ -2 \1 /g; 
    s/-(beta)/ -3 \1 /g; 
    s/-(alpha)/ -4 \1 /g;
    '
}

version_repack () {
  sed -re '
    s/ -[0-9]+ ([a-z]+) /-\1/g;
    s@ / @/@g
    s/ /./g; 
    '
}

version_sort () {
  version_unpack | 
    sort -t ' ' -k 1n -k 2n -k 3n -k 4n -k 5n -k 6n -k 7n -n | tac |
    version_repack
}

position_choice () {
  head -n "${1:-1}" | tail -n "${2:-1}"
}

matching_links () {
  "$own_dir"/urls-from-page.sh "$CURRENT_URL" | grep -E "$1"
}

link () {
  CURRENT_URL="$(matching_links "$1" | position_choice "$2" "$3")"
  echo "Linked by: $*"
  echo "URL: $CURRENT_URL" >&2
}

version_link () {
  CURRENT_URL="$(matching_links "$1" | version_sort | position_choice "$2" "$3")"
  echo "Linked version by: $*"
  echo "URL: $CURRENT_URL" >&2
}

redirect () {
  CURRENT_URL="$(curl -I -L --max-redirs "${1:-99}" "$CURRENT_URL" | 
    grep -E '^Location: ' | position_choice "${2:-999999}" "$3" |
    sed -e 's/^Location: //; s/\r//')"
  echo "Redirected: $*"
  echo "URL: $CURRENT_URL" >&2
}

replace () {
  sed -re "s	$1	$2	g"
}

process () {
  CURRENT_URL="$(echo "$CURRENT_URL" | replace "$1" "$2")"
  echo "Processed: $*"
  echo "URL: $CURRENT_URL" >&2
}

version () {
  CURRENT_VERSION="$(echo "$CURRENT_URL" | replace "$1" "$2")"
  echo "Version: $CURRENT_VERSION" >&2
}

ensure_version () {
  [ -z "$CURRENT_VERSION" ] && version '.*-([0-9.]+)[-._].*' '\1'
}

hash () {
  CURRENT_HASH="$(nix-prefetch-url "$CURRENT_URL")"
}

name () {
  CURRENT_NAME="$1"
}

retrieve_version () {
  PACKAGED_VERSION="$(nix-instantiate --eval-only '<nixpkgs>' -A "$CURRENT_NAME".meta.version | xargs)"
}

directory_of () {
  cd "$(dirname "$1")"; pwd
}

full_path () {
  echo "$(directory_of "$1")/$(basename "$1")"
}

target () {
  CURRENT_TARGET="$1"
  test -e "$CURRENT_TARGET" || 
    { [ "$CURRENT_TARGET" = "${CURRENT_TARGET#/}" ] && CURRENT_TARGET="$CONFIG_DIR/$CURRENT_TARGET"; }
  echo "Target set to: $CURRENT_TARGET"
}

update_found () {
  echo "Compare: $CURRENT_VERSION vs $PACKAGED_VERSION"
  [ "$CURRENT_VERSION" != "$PACKAGED_VERSION" ]
}

do_regenerate () {
  cat "$1" | grep -F '# Generated upstream information' -B 999999;
  echo "  rec {"
  echo "    baseName=\"$CURRENT_NAME\";"
  echo "    version=\"$CURRENT_VERSION\";"
  echo '    name="${baseName}-${version}";'
  echo "    hash=\"$CURRENT_HASH\";"
  echo "    url=\"$CURRENT_URL\";"
  cat "$1" | grep -F '# Generated upstream information' -A 999999 | grep -E '^ *[}]; *$' -A 999999;
}

do_overwrite () {
  hash
  do_regenerate "$1" > "$1.new.tmp"
  mv "$1.new.tmp" "$1"
}

process_config () {
  CONFIG_DIR="$(directory_of "$1")"
  source "$CONFIG_DIR/$(basename "$1")"
  retrieve_version
  ensure_version
  update_found && do_overwrite "$CURRENT_TARGET"
}

process_config "$1"
