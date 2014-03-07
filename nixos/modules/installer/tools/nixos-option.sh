#! @shell@ -e

# FIXME: rewrite this in a more suitable language.

usage () {
    exec man nixos-option
    exit 1
}

#####################
# Process Arguments #
#####################

desc=false
defs=false
value=false
xml=false
verbose=false

option=""

argfun=""
for arg; do
  if test -z "$argfun"; then
    case $arg in
      -*)
        longarg=""
        sarg="$arg"
        while test "$sarg" != "-"; do
          case $sarg in
            --*) longarg=$arg; sarg="--";;
            -d*) longarg="$longarg --description";;
            -v*) longarg="$longarg --value";;
            -l*) longarg="$longarg --lookup";;
            -*) usage;;
          esac
          # remove the first letter option
          sarg="-${sarg#??}"
        done
        ;;
      *) longarg=$arg;;
    esac
    for larg in $longarg; do
      case $larg in
        --description) desc=true;;
        --value) value=true;;
        --lookup) defs=true;;
        --xml) xml=true;;
        --verbose) verbose=true;;
        --help) usage;;
        -*) usage;;
        *) if test -z "$option"; then
             option="$larg"
           else
             usage
           fi;;
      esac
    done
  else
    case $argfun in
      set_*)
        var=$(echo $argfun | sed 's,^set_,,')
        eval $var=$arg
        ;;
    esac
    argfun=""
  fi
done

if $xml; then
  value=true
  desc=true
  defs=true
fi

if ! $defs && ! $desc; then
  value=true
fi

if $verbose; then
  set -x
else
  set +x
fi

#############################
# Process the configuration #
#############################

evalNix(){
  nix-instantiate - --eval-only "$@"
}

evalAttr(){
  local prefix="$1"
  local strict="$2"
  local suffix="$3"
  echo "(import <nixos> {}).$prefix${option:+.$option}${suffix:+.$suffix}" |
    evalNix ${strict:+--strict}
}

evalOpt(){
  evalAttr "options" "" "$@"
}

evalCfg(){
  local strict="$1"
  evalAttr "config" "$strict"
}

findSources(){
  local suffix=$1
  echo "(import <nixos> {}).options${option:+.$option}.$suffix" |
    evalNix --strict
}

# Given a result from nix-instantiate, recover the list of attributes it
# contains.
attrNames() {
  local attributeset=$1
  # sed is used to replace un-printable subset by 0s, and to remove most of
  # the inner-attribute set, which reduce the likelyhood to encounter badly
  # pre-processed input.
  echo "builtins.attrNames $attributeset" | \
    sed 's,<[A-Z]*>,0,g; :inner; s/{[^\{\}]*};/0;/g; t inner;' | \
    evalNix --strict
}

# map a simple list which contains strings or paths.
nixMap() {
  local fun="$1"
  local list="$2"
  local elem
  for elem in $list; do
    test $elem = '[' -o $elem = ']' && continue;
    $fun $elem
  done
}

# This duplicates the work made below, but it is useful for processing
# the output of nixos-option with other tools such as nixos-gui.
if $xml; then
  evalNix --xml --no-location <<EOF
let
  reach = attrs: attrs${option:+.$option};
  nixos = import <nixos> {};
  nixpkgs = import <nixpkgs> {};
  sources = builtins.map (f: f.source);
  opt = reach nixos.options;
  cfg = reach nixos.config;
in

with nixpkgs.lib;

let
  optStrict = v:
    let
      traverse = x :
        if isAttrs x then
          if x ? outPath then true
          else all id (mapAttrsFlatten (n: traverseNoAttrs) x)
        else traverseNoAttrs x;
      traverseNoAttrs = x:
        # do not continue in attribute sets
        if isAttrs x then true
        else if isList x then all id (map traverse x)
        else true;
    in assert traverse v; v;
in

if isOption opt then
  optStrict ({}
  // optionalAttrs (opt ? default) { inherit (opt) default; }
  // optionalAttrs (opt ? example) { inherit (opt) example; }
  // optionalAttrs (opt ? description) { inherit (opt) description; }
  // optionalAttrs (opt ? type) { typename = opt.type.name; }
  // optionalAttrs (opt ? options) { inherit (opt) options; }
  // {
    # to disambiguate the xml output.
    _isOption = true;
    declarations = sources opt.declarations;
    definitions = sources opt.definitions;
    value = cfg;
  })
else
  opt
EOF
  exit $?
fi

if test "$(evalOpt "_type" 2> /dev/null)" = '"option"'; then
  $value && evalCfg 1

  if $desc; then
    $value && echo;

    if default=$(evalOpt "default" - 2> /dev/null); then
      echo "Default: $default"
    else
      echo "Default: <None>"
    fi
    if example=$(evalOpt "example" - 2> /dev/null); then
      echo "Example: $example"
    fi
    echo "Description:"
    eval printf $(evalOpt "description")
  fi

  if $defs; then
    $desc || $value && echo;

    printPath () { echo "  $1"; }

    echo "Declared by:"
    nixMap printPath "$(findSources "declarations")"
    echo ""
    echo "Defined by:"
    nixMap printPath "$(findSources "files")"
    echo ""
  fi

else
  # echo 1>&2 "Warning: This value is not an option."

  result=$(evalCfg "")
  if names=$(attrNames "$result" 2> /dev/null); then
    echo 1>&2 "This attribute set contains:"
    escapeQuotes () { eval echo "$1"; }
    nixMap escapeQuotes "$names"
  else
    echo 1>&2 "An error occurred while looking for attribute names."
    echo $result
  fi
fi
