#! @shell@

show_help() {
  cat << EOF
Usage: nixos-version [options]

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
      # TODO
      #exec man nixos-version
      ;;
    *)
      echo "nixos-version: unrecognized option '$1'"
      echo "Type 'nixos-version -h' for a list of available options."
      exit 1
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

# TODO: Default?
#echo "@nixosVersion@ (@nixosCodeName@)"
if [[ "$all" = "1" ]] || [[ "$version" = "1" ]] || \
   ([[ "$id" = "0" ]] && [[ "$description" = "0" ]] && \
    [[ "$release" = "0" ]] && [[ "$codename" = "0" ]]); then
  echo "No LSB modules are available."
fi

# Now output the data - The order of these was chosen to match
# what the original lsb_release used, and while I suspect it doesn't
# matter I kept it the same.
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
  # TODO: echo "@nixosRevision@"?
  # Revision comes from: VERSION="16.09.git.effc189 (Flounder)" -> effc189
  echo $(echo $VERSION_ID | rev | cut -d. -f1 | rev)
fi

if [[ "$all" = "1" ]] || [[ "$codename" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Codename:\t"
  fi
  echo $(echo $VERSION_CODENAME)
fi

exit 0
