#! /bin/sh

own_dir="$(cd "$(dirname "$0")"; pwd)"

CURRENT_URL=
NEED_TO_CHOOSE_URL=1

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
    s/[-]/ - /g; 
    '
}

version_repack () {
  sed -re '
    s/ - /-/g;
    s/ -[0-9]+ ([a-z]+) /-\1/g;
    s@ / @/@g
    s/ /./g; 
    '
}

version_sort () {
  version_unpack | 
    sort -t ' ' -n $(for i in $(seq 30); do echo " -k${i}n" ; done) | tac |
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
  unset NEED_TO_CHOOSE_URL
  echo "Linked by: $*"
  echo "URL: $CURRENT_URL" >&2
}

version_link () {
  CURRENT_URL="$(matching_links "$1" | version_sort | position_choice "$2" "$3")"
  unset NEED_TO_CHOOSE_URL
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
  echo "Ensuring version. CURRENT_VERSION: $CURRENT_VERSION" >&2
  [ -z "$CURRENT_VERSION" ] && version '.*-([0-9.]+)[-._].*' '\1'
}

ensure_target () {
  echo "Ensuring target. CURRENT_TARGET: $CURRENT_TARGET" >&2
  [ -z "$CURRENT_TARGET" ] && target "$(basename "$CONFIG_NAME" .upstream).nix"
}

ensure_name () {
  echo "Ensuring name. CURRENT_NAME: $CURRENT_NAME" >&2
  [ -z "$CURRENT_NAME" ] && name "$(basename "$CONFIG_DIR")"
  echo "Resulting name: $CURRENT_NAME"
}

ensure_attribute_name () {
  echo "Ensuring attribute name. CURRENT_ATTRIBUTE_NAME: $CURRENT_ATTRIBUTE_NAME" >&2
  [ -z "$CURRENT_ATTRIBUTE_NAME" ] && attribute_name "$CURRENT_NAME"
  echo "Resulting attribute name: $CURRENT_ATTRIBUTE_NAME"
}

ensure_choice () {
  echo "Ensuring that choice is made." >&2
  echo "NEED_TO_CHOOSE_URL: [$NEED_TO_CHOOSE_URL]." >&2
  echo "CURRENT_URL: $CURRENT_URL" >&2
  [ -n "$NEED_TO_CHOOSE_URL" ] && {
    version_link '[.]tar[.]([^./])+$'
    unset NEED_TO_CHOOSE_URL
  }
  [ -z "$CURRENT_URL" ] && {
    echo "Error: empty CURRENT_URL"
    echo "Error: empty CURRENT_URL" >&2
    exit 1
  }
}

ensure_hash () {
  echo "Ensuring hash. CURRENT_HASH: $CURRENT_HASH" >&2
  [ -z "$CURRENT_HASH" ] && hash
}

hash () {
  CURRENT_HASH="$(nix-prefetch-url "$CURRENT_URL")"
  echo "CURRENT_HASH: $CURRENT_HASH" >&2
}

name () {
  CURRENT_NAME="$1"
  echo "CURRENT_NAME: $CURRENT_NAME" >&2
}

attribute_name () {
  CURRENT_ATTRIBUTE_NAME="$1"
  echo "CURRENT_ATTRIBUTE_NAME: $CURRENT_ATTRIBUTE_NAME" >&2
}

retrieve_version () {
  PACKAGED_VERSION="$(nix-instantiate --eval-only '<nixpkgs>' -A "$CURRENT_ATTRIBUTE_NAME".meta.version | xargs)"
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

marker () {
  BEGIN_EXPRESSION="$1"
}

update_found () {
  echo "Compare: $CURRENT_VERSION vs $PACKAGED_VERSION"
  [ "$CURRENT_VERSION" != "$PACKAGED_VERSION" ]
}

do_write_expression () {
  echo "${1}rec {"
  echo "${1}  baseName=\"$CURRENT_NAME\";"
  echo "${1}  version=\"$CURRENT_VERSION\";"
  echo "${1}  name=\"\${baseName}-\${version}\";"
  echo "${1}  hash=\"$CURRENT_HASH\";"
  echo "${1}  url=\"$CURRENT_URL\";"
  echo "${1}  sha256=\"$CURRENT_HASH\";"
  echo "$2"
}

line_position () {
  file="$1"
  regexp="$2"
  count="${3:-1}"
  grep -E "$regexp" -m "$count" -B 999999 "$file" | wc -l
}

replace_once () {
  file="$1"
  regexp="$2"
  replacement="$3"
  instance="${4:-1}"

  position="$(line_position "$file" "$regexp" "$instance")"
  sed -re "${position}s	$regexp	$replacement	" -i "$file"
}

set_var_value () {
  var="${1}"
  value="${2}"
  instance="${3:-1}"
  file="${4:-$CURRENT_TARGET}"
  no_quotes="${5:-0}"

  quote='"'
  let "$no_quotes" && quote=""

  replace_once "$file" "${var} *= *.*" "${var} = ${quote}${value}${quote};"
}

do_regenerate () {
  BEFORE="$(cat "$1" | grep -F "$BEGIN_EXPRESSION" -B 999999;)"
  AFTER_EXPANDED="$(cat "$1" | grep -F "$BEGIN_EXPRESSION" -A 999999 | grep -E '^ *[}] *; *$' -A 999999;)"
  AFTER="$(echo "$AFTER_EXPANDED" | tail -n +2)"
  CLOSE_BRACE="$(echo "$AFTER_EXPANDED" | head -n 1)"
  SPACING="$(echo "$CLOSE_BRACE" | sed -re 's/[^ ].*//')"

  echo "$BEFORE"
  do_write_expression "$SPACING" "$CLOSE_BRACE"
  echo "$AFTER"
}

do_overwrite () {
  ensure_hash
  do_regenerate "$1" > "$1.new.tmp"
  mv "$1.new.tmp" "$1"
}

process_config () {
  CONFIG_DIR="$(directory_of "$1")"
  CONFIG_NAME="$(basename "$1")"
  BEGIN_EXPRESSION='# Generated upstream information';
  source "$CONFIG_DIR/$CONFIG_NAME"
  ensure_name
  ensure_attribute_name
  retrieve_version
  ensure_choice
  ensure_version
  ensure_target
  update_found && do_overwrite "$CURRENT_TARGET"
}

source "$own_dir/update-walker-service-specific.sh"

process_config "$1"
