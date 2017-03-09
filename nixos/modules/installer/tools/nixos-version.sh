#! @shell@

# Program name (e.g. /.../nixos-version -> nixos-version)
# Helps with alternative names like lsb_release
pname="${0##*/}"

show_help() {
  cat << EOF
Usage: $pname [options]

Options:
  -h, --help         show this help message and exit
  -v, --version      show LSB modules this system supports
  -i, --id           show distributor ID
  -d, --description  show description of this distribution
  -r, --release      show release number of this distribution
  --revision, --hash show revision (abbreviated commit hash) of this distribution
  -c, --codename     show code name of this distribution
  -a, --all          show all of the above information
  -s, --short        show requested information in short format
EOF
  exit 0
}

# Potential command-line options.
version=0
id=0
description=0
release=0
revision=0
codename=0
all=0
short=0

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
  # This shouldn't happen on any recent GNU system.
  echo "Enhanced getopt not supported, please open an issue."
else
  # Define all short and long options.
  SHORT=hvidrcas
  LONG=help,version,id,description,release,revision,hash,codename,all,short

  # Parse all options.
  PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
  if [[ $? -ne 0 ]]; then
    # getopt will print an error
    exit 1
  fi

  eval set -- "$PARSED"
fi


# Process each argument, and set the appropriate flag if we recognize it.
while [[ $# -ge 1 ]]; do
  case $1 in
    -v|--version)
      version=1
      ;;
    -i|--id)
      id=1
      ;;
    -d|--description)
      description=1
      ;;
    -r|--release)
      release=1
      ;;
    --revision|--hash)
      revision=1
      ;;
    -c|--codename)
      codename=1
      ;;
    -a|--all)
      all=1
      ;;
    -s|--short)
      short=1
      ;;
    -h|--help)
      show_help
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "$pname: unrecognized option '$1'"
      echo "Type '$pname -h' for a list of available options."
      exit 1
      ;;
  esac
  shift
done

#  Read our variables.
if [[ -e /etc/os-release ]]; then
  . /etc/os-release
else
  echo "/etc/os-release is not present.  Aborting" >&2
  exit 1
fi

# Default output (depending on the executable name)
# Stays compatible to nixos-version *and* lsb_release
if [[ "$version" = "0" ]] && [[ "$id" = "0" ]] && \
   [[ "$description" = "0" ]] && [[ "$release" = "0" ]] && \
   [[ "$revision" = "0" ]] && [[ "$codename" = "0" ]] && \
   [[ "$all" = "0" ]]; then
  if [[ $pname = "lsb_release" ]]; then
    echo "No LSB modules are available."
  else
    echo $VERSION
    # was: echo "@nixosVersion@ (@nixosCodeName@)"
  fi
  exit 0
fi

# Now output the data - The order of these was chosen to match
# what the original lsb_release used.

if [[ "$all" = "1" ]] || [[ "$version" = "1" ]]; then
  echo "No LSB modules are available."
fi

if [[ "$all" = "1" ]] || [[ "$id" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Distributor ID:\t"
  fi
  echo $NAME
fi

if [[ "$all" = "1" ]] || [[ "$description" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Description:\t"
  fi
  echo $PRETTY_NAME
fi

if [[ "$all" = "1" ]] || [[ "$release" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Release:\t"
  fi
  echo $VERSION_ID
fi

# TODO: For all (incompatible with lsb_release)?
if [[ "$all" = "1" ]] || [[ "$revision" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Revision:\t"
  fi
  # Revision comes from: VERSION_ID="16.09.git.effc189" -> effc189
  echo $(echo $VERSION_ID | rev | cut -d. -f1 | rev)
  # was: echo "@nixosRevision@"
fi

if [[ "$all" = "1" ]] || [[ "$codename" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Codename:\t"
  fi
  echo $(echo $VERSION_CODENAME)
fi

# Success
exit 0
