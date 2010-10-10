#! @shell@ -e

# Allow the location of NixOS sources and the system configuration
# file to be overridden.

: ${mountPoint=/mnt}
: ${NIXOS=/etc/nixos/nixos}
: ${NIXOS_CONFIG=/etc/nixos/configuration.nix}
: ${NIXPKGS=/etc/nixos/nixpkgs}
export NIXOS

usage () {
  echo 1>&2 "
Usage: $0 [--install] [-v] [-d] [-l] OPTION_NAME
       $0 [--install]

This program is used to explore NixOS options by looking at their values or
by looking at their description.  It is helpful for understanding how your
configuration is working.

Options:

  -i | --install        Use the configuration on
                        ${mountPoint:+$mountPoint/}$NIXOS_CONFIG instead of
                        the current system configuration.  Generate a
                        template configuration if no option name is
                        specified.
  -v | --value          Display the current value, based on your
                        configuration.
  -d | --description    Display the default value, the example and the
                        description.
  -l | --lookup         Display where the option is defined and where it
                        is declared.
  --help                Show this message.

Environment variables affecting $0:

  \$mountPoint          Path to the target file system.
  \$NIXOS               Path where the NixOS repository is located.
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
            --*) longarg=$arg;;
            -d*) longarg="$longarg --description";;
            -v*) longarg="$longarg --value";;
            -l*) longarg="$longarg --lookup";;
            -i*) longarg="$longarg --install";;
            -*) usage;;
          esac
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

evalAttr(){
  local prefix=$1
  local suffix=$2
  local strict=$3
  echo "(import $NIXOS {}).$prefix${option:+.$option}${suffix:+.$suffix}" |
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
  echo "builtins.map (f: f.source) (import $NIXOS {}).eval.options${option:+.$option}.$suffix" |
    nix-instantiate - --eval-only --strict
}

if $install; then
  if test -e "$mountPoint$NIXOS"; then
    export NIXOS="$mountPoint$NIXOS"
  fi
  if test -e "$mountPoint$NIXPKGS"; then
    export NIXPKGS="$mountPoint$NIXPKGS"
  fi
  export NIXOS_CONFIG="$mountPoint$NIXOS_CONFIG"
fi

if $generate; then
  mkdir -p $(dirname "$NIXOS_CONFIG")

  # Scan the hardware and add the result to /etc/nixos/hardware-scan.nix.
  hardware_config="${NIXOS_CONFIG%/configuration.nix}/hardware-configuration.nix"
  if test -e "$hardware_config"; then
    echo "A hardware configuration file exists, generation skipped."
  else
    echo "Scan your hardware to generate a hardware configuration file."
    nixos-hardware-scan > "$hardware_config"
  fi

  if test -e "$NIXOS_CONFIG"; then
    echo 1>&2 "error: Cannot generate a template configuration because a configuration file exists."
    exit 1
  fi

  echo "Generate a template configuration that you should edit."

  # Generate a template configuration file where the user has to
  # fill the gaps.
  echo > "$NIXOS_CONFIG" \
'# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{config, pkgs, ...}:

{
  require = [
    # Include the configuration for part of your system which have been
    # detected automatically.  In addition, it includes the same
    # configuration as the installation device that you used.
    ./hardware-configuration.nix
  ];

  boot.initrd.kernelModules = [
    # Specify all kernel modules that are necessary for mounting the root
    # file system.
    #
    # "ext4" "ata_piix"
  ];

  boot.loader.grub = {
    # Use grub 2 as boot loader.
    enable = true;
    version = 2;

    # Define on which hard drive you want to install Grub.
    # device = "/dev/sda";
  };

  networking = {
    # hostName = "nixos"; # Define your hostname.
    interfaceMonitor.enable = true; # Watch for plugged cable.
    enableWLAN = true;  # Enables Wireless.
  };

  # Add file system entries for each partition that you want to see mounted
  # at boot time.  You can add filesystems which are not mounted at boot by
  # adding the noauto option.
  fileSystems = [
    # Mount the root file system
    #
    # { mountPoint = "/";
    #   device = "/dev/sda2";
    # }

    # Copy & Paste & Uncomment & Modify to add any other file system.
    #
    # { mountPoint = "/data"; # where you want to mount the device
    #   device = "/dev/sdb"; # the device or the label of the device
    #   # label = "data";
    #   fsType = "ext3";      # the type of the partition.
    #   options = "data=journal";
    # }
  ];

  swapDevices = [
    # List swap partitions that are mounted at boot time.
    #
    # { device = "/dev/sda1"; }
  ];

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List services that you want to enable:

  # Add an OpenSSH daemon.
  # services.openssh.enable = true;

  # Add CUPS to print documents.
  # services.printing.enable = true;

  # Add XServer (default if you have used a graphical iso)
  # services.xserver = {
  #   enable = true;
  #   layout = "us";
  #   xkbOptions = "eurosign:e";
  # };

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
}
'

  exit 0
fi;

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
