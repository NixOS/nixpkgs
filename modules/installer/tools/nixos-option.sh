#! @shell@ -e

# Allow the location of NixOS sources and the system configuration
# file to be overridden.
: ${NIXOS_PATH=/etc/nixos/nixos}
: ${NIXOS=/etc/nixos/nixos}
: ${NIXPKGS=/etc/nixos/nixpkgs}
: ${NIXOS_CONFIG=/etc/nixos/configuration.nix}
export NIXOS_PATH

usage () {
  echo 1>&2 "
Usage: $0 OPTION_NAME [-v] [-d] [-l]

This program is used to explore NixOS options by looking at their values or
by looking at their description.  It is helpful for understanding the how
your configuration is working.

Options:

  -v | --value          Display the current value, based on your
                        configuration.
  -d | --default        Display the default value, the example and the
                        description.
  -l | --lookup         Display where the option is defined and where it
                        is declared.
  --help                Show this message.

Environment variables affecting nixos-option:

  \$NIXOS_PATH          Path where the NixOS repository is located.
  \$NIXOS_CONFIG        Path to your configuration file.
  \$NIXPKGS             Path to Nix packages.

"

  exit 1;
}

#####################
# Process Arguments #
#####################

desc=false
defs=false
value=false
verbose=false

option=""

argfun=""
for arg; do
  if test -z "$argfun"; then
    case $arg in
      -d|--description) desc=true;;
      -v|--value) value=true;;
      -l|--lookup) defs=true;;
      --verbose) verbose=true;;
      --help) usage;;
      -*) usage;;
      *) if test -z "$option"; then
           option="$arg"
         else
           usage
         fi;;
    esac
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

evalAttr(){
  local prefix=$1
  local suffix=$2
  local strict=$3
  echo "(import $NIXOS_PATH {}).$prefix${option:+.$option}${suffix:+.$suffix}" |
    nix-instantiate - --eval-only ${strict:+--strict}
}

evalOpt(){
  evalAttr "eval.options" "$@"
}

evalCfg(){
  evalAttr "config" "$@"
}

findSources(){
  local suffix=$1
  echo "builtins.map (f: f.source) (import $NIXOS_PATH {}).eval.options${option:+.$option}.$suffix" |
    nix-instantiate - --eval-only --strict
}



if test "$(evalOpt "_type" 2> /dev/null)" = '"option"'; then
  $value && evalCfg;

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

    echo "Declared by:"
    for f in $(findSources "declarations"); do
      test $f = '[' -o $f = ']' && continue;
      echo "  $f"
    done
    echo ""
    echo "Defined by:"
    for f in $(findSources "definitions"); do
      test $f = '[' -o $f = ']' && continue;
      echo "  $f"
    done
    echo ""
  fi

else
  # echo 1>&2 "Warning: This value is not an option."

  result=$(evalCfg)
  if names=$(echo "builtins.attrNames $result" | sed 's,<CODE>,"<CODE>",g' | nix-instantiate - --eval-only --strict 2> /dev/null); then
    echo 1>&2 "This attribute set contains:" 
    for attr in $names; do
      test $attr = '[' -o $attr = ']' && continue;
      eval echo $attr # escape extra double-quotes in the attribute name.
    done
  else
    echo $result
  fi
fi
