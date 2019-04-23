#! @shell@ -e

# FIXME: rewrite this in a more suitable language.

usage () {
    exec man nixos-option
    exit 1
}

#####################
# Process Arguments #
#####################

xml=false
verbose=false
nixPath=""

option=""
exit_code=0

argfun=""
for arg; do
  if test -z "$argfun"; then
    case $arg in
      -*)
        sarg="$arg"
        longarg=""
        while test "$sarg" != "-"; do
          case $sarg in
            --*) longarg=$arg; sarg="--";;
            -I) argfun="include_nixpath";;
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
      include_nixpath)
        nixPath="-I $arg $nixPath"
        ;;
    esac
    argfun=""
  fi
done

if $verbose; then
  set -x
else
  set +x
fi

#############################
# Process the configuration #
#############################

evalNix(){
  # disable `-e` flag, it's possible that the evaluation of `nix-instantiate` fails (e.g. due to broken pkgs)
  set +e
  result=$(nix-instantiate ${nixPath:+$nixPath} - --eval-only "$@" 2>&1)
  exit_code=$?
  set -e

  if test $exit_code -eq 0; then
      sed '/^warning: Nix search path/d' <<EOF
$result
EOF
      return 0;
  else
      sed -n '
  /^error/ { s/, at (string):[0-9]*:[0-9]*//; p; };
  /^warning: Nix search path/ { p; };
' >&2 <<EOF
$result
EOF
    exit_code=1
  fi
}

header="let
  nixos = import <nixpkgs/nixos> {};
  nixpkgs = import <nixpkgs> {};
in with nixpkgs.lib;
"

# This function is used for converting the option definition path given by
# the user into accessors for reaching the definition and the declaration
# corresponding to this option.
generateAccessors(){
  if result=$(evalNix --strict --show-trace <<EOF
$header

let
  path = "${option:+$option}";
  pathList = splitString "." path;

  walkOptions = attrsNames: result:
    if attrsNames == [] then
      result
    else
      let name = head attrsNames; rest = tail attrsNames; in
      if isOption result.options then
        walkOptions rest {
          options = result.options.type.getSubOptions "";
          opt = ''(\${result.opt}.type.getSubOptions "")'';
          cfg = ''\${result.cfg}."\${name}"'';
        }
      else
        walkOptions rest {
          options = result.options.\${name};
          opt = ''\${result.opt}."\${name}"'';
          cfg = ''\${result.cfg}."\${name}"'';
        }
    ;

  walkResult = (if path == "" then x: x else walkOptions pathList) {
    options = nixos.options;
    opt = ''nixos.options'';
    cfg = ''nixos.config'';
  };

in
  ''let option = \${walkResult.opt}; config = \${walkResult.cfg}; in''
EOF
)
  then
      echo $result
  else
      # In case of error we want to ignore the error message roduced by the
      # script above, as it is iterating over each attribute, which does not
      # produce a nice error message.  The following code is a fallback
      # solution which is cause a nicer error message in the next
      # evaluation.
      echo "\"let option = nixos.options${option:+.$option}; config = nixos.config${option:+.$option}; in\""
  fi
}

header="$header
$(eval echo $(generateAccessors))
"

evalAttr(){
  local prefix="$1"
  local strict="$2"
  local suffix="$3"

  # If strict is set, then set it to "true".
  test -n "$strict" && strict=true

  evalNix ${strict:+--strict} <<EOF
$header

let
  value = $prefix${suffix:+.$suffix};
  strict = ${strict:-false};
  cleanOutput = x: with nixpkgs.lib;
    if isDerivation x then x.outPath
    else if isFunction x then "<CODE>"
    else if strict then
      if isAttrs x then mapAttrs (n: cleanOutput) x
      else if isList x then map cleanOutput x
      else x
    else x;
in
  cleanOutput value
EOF
}

evalOpt(){
  evalAttr "option" "" "$@"
}

evalCfg(){
  local strict="$1"
  evalAttr "config" "$strict"
}

findSources(){
  local suffix=$1
  evalNix --strict <<EOF
$header

option.$suffix
EOF
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
$header

let
  sources = builtins.map (f: f.source);
  opt = option;
  cfg = config;
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
  // optionalAttrs (opt ? type) { typename = opt.type.description; }
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
  echo "Value:"
  evalCfg 1

  echo

  echo "Default:"
  if default=$(evalOpt "default" - 2> /dev/null); then
    echo "$default"
  else
    echo "<None>"
  fi
  echo
  if example=$(evalOpt "example" - 2> /dev/null); then
    echo "Example:"
    echo "$example"
    echo
  fi
  echo "Description:"
  echo
  echo $(evalOpt "description")

  echo $desc;

  printPath () { echo "  $1"; }

  echo "Declared by:"
  nixMap printPath "$(findSources "declarations")"
  echo
  echo "Defined by:"
  nixMap printPath "$(findSources "files")"
  echo

else
  # echo 1>&2 "Warning: This value is not an option."

  result=$(evalCfg "")
  if [ ! -z "$result" ]; then
    names=$(attrNames "$result" 2> /dev/null)
    echo 1>&2 "This attribute set contains:"
    escapeQuotes () { eval echo "$1"; }
    nixMap escapeQuotes "$names"
  else
    echo 1>&2 "An error occurred while looking for attribute names. Are you sure that '$option' exists?"
  fi
fi

exit $exit_code
