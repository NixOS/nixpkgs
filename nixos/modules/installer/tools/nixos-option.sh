#! @shell@ -e

# Allow the location of NixOS sources and the system configuration
# file to be overridden.

: ${mountPoint=/mnt}
: ${NIXOS_CONFIG=/etc/nixos/configuration.nix}
export NIXOS_CONFIG

usage () {
    exec man nixos-rebuild
    exit 1
}

#####################
# Process Arguments #
#####################

desc=false
defs=false
value=false
xml=false
install=false
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
            -i*) longarg="$longarg --install";;
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
        --install) install=true;;
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

# --install cannot be used with -d -v -l without option name.
if $value || $desc || $defs && $install && test -z "$option"; then
  usage
fi

generate=false
if ! $defs && ! $desc && ! $value && $install && test -z "$option"; then
  generate=true
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
  local prefix=$1
  local suffix=$2
  local strict=$3
  echo "(import <nixos> {}).$prefix${option:+.$option}${suffix:+.$suffix}" |
    evalNix ${strict:+--strict}
}

evalOpt(){
  evalAttr "eval.options" "$@"
}

evalCfg(){
  evalAttr "config" "$@"
}

findSources(){
  local suffix=$1
  echo "builtins.map (f: f.source) (import <nixos> {}).eval.options${option:+.$option}.$suffix" |
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

if $install; then
  NIXOS_CONFIG="$mountPoint$NIXOS_CONFIG"
fi

if $generate; then
  mkdir -p $(dirname "$NIXOS_CONFIG")

  # Scan the hardware and add the result to /etc/nixos/hardware-scan.nix.
  hardware_config="${NIXOS_CONFIG%/configuration.nix}/hardware-configuration.nix"
  if test -e "$hardware_config"; then
    echo "A hardware configuration file exists, generation skipped."
  else
    echo "Generating a hardware configuration file in $hardware_config..."
    nixos-hardware-scan > "$hardware_config"
  fi

  if test -e "$NIXOS_CONFIG"; then
    echo 1>&2 "error: Cannot generate a template configuration because a configuration file exists."
    exit 1
  fi

  nl="
"
  if test -e /sys/firmware/efi/efivars; then
    l1="  # Use the gummiboot efi boot loader."
    l2="  boot.loader.grub.enable = false;"
    l3="  boot.loader.gummiboot.enable = true;"
    l4="  boot.loader.efi.canTouchEfiVariables = true;"
    # !!! Remove me when nixos is on 3.10 or greater by default
    l5="  # EFI booting requires kernel >= 3.10"
    l6="  boot.kernelPackages = pkgs.linuxPackages_3_10;"
    bootloader_config="$l1$nl$l2$nl$l3$nl$l4$nl$nl$l5$nl$l6"
  else
    l1="  # Use the Grub2 boot loader."
    l2="  boot.loader.grub.enable = true;"
    l3="  boot.loader.grub.version = 2;"
    l4="  # Define on which hard drive you want to install Grub."
    l5='  # boot.loader.grub.device = "/dev/sda";'
    bootloader_config="$l1$nl$l2$nl$l3$nl$nl$l4$nl$l5"
  fi

  echo "Generating a basic configuration file in $NIXOS_CONFIG..."

  # Generate a template configuration file where the user has to
  # fill the gaps.
  cat <<EOF > "$NIXOS_CONFIG"
# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
      # fbcon # Uncomment this when EFI booting to see the console before the root partition is mounted
    ];
    
$bootloader_config

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables Wireless.

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  # fileSystems."/".device = "/dev/disk/by-label/nixos";

  # fileSystems."/data" =     # where you want to mount the device
  #   { device = "/dev/sdb";  # the device
  #     fsType = "ext3";      # the type of the partition
  #     options = "data=journal";
  #   };

  # List swap partitions activated at boot time.
  swapDevices =
    [ # { device = "/dev/disk/by-label/swap"; }
    ];

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;
}
EOF

  exit 0
fi;

# This duplicates the work made below, but it is useful for processing
# the output of nixos-option with other tools such as nixos-gui.
if $xml; then
  evalNix --xml --no-location <<EOF
let
  reach = attrs: attrs${option:+.$option};
  nixos = import <nixos> {};
  nixpkgs = import <nixpkgs> {};
  sources = builtins.map (f: f.source);
  opt = reach nixos.eval.options;
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

    printPath () { echo "  $1"; }

    echo "Declared by:"
    nixMap printPath "$(findSources "declarations")"
    echo ""
    echo "Defined by:"
    nixMap printPath "$(findSources "definitions")"
    echo ""
  fi

else
  # echo 1>&2 "Warning: This value is not an option."

  result=$(evalCfg)
  if names=$(attrNames "$result" 2> /dev/null); then
    echo 1>&2 "This attribute set contains:"
    escapeQuotes () { eval echo "$1"; }
    nixMap escapeQuotes "$names"
  else
    echo 1>&2 "An error occured while looking for attribute names."
    echo $result
  fi
fi
