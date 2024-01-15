#! @shell@

set -o errexit
set -o nounset

show_help() {
  @coreutils@/bin/cat << EOF
Usage: uname [OPTION]...
Print certain system information.  With no OPTION, same as -s.

  -a, --all                print all information, in the following order,
                             except omit -p and -i if unknown:
  -s, --kernel-name        print the kernel name
  -n, --nodename           print the network node hostname
  -r, --kernel-release     print the kernel release
  -v, --kernel-version     print the kernel version
  -m, --machine            print the machine hardware name
  -p, --processor          print the processor type (non-portable)
  -i, --hardware-platform  print the hardware platform (non-portable)
  -o, --operating-system   print the operating system
      --help        display this help and exit
      --version     output version information and exit
EOF
  exit 0
}

# Potential command-line options.
version=0
all=0


kernel_name=0
nodename=0
kernel_release=0
kernel_version=0
machine=0
processor=0
hardware_platform=0
operating_system=0

# With no OPTION, same as -s.
if [[ $# -eq 0 ]]; then
    kernel_name=1
fi

@getopt@/bin/getopt --test > /dev/null && rc=$? || rc=$?
if [[ $rc -ne 4 ]]; then
  # This shouldn't happen.
  echo "Warning: Enhanced getopt not supported, please open an issue in nixpkgs." >&2
else
  # Define all short and long options.
  SHORT=hvsnrvmpioa
  LONG=help,version,kernel-name,nodename,kernel-release,kernel-version,machine,processor,hardware-platform,operating-system,all

  # Parse all options.
  PARSED=`@getopt@/bin/getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`

  eval set -- "$PARSED"
fi

# Process each argument, and set the appropriate flag if we recognize it.
while [[ $# -ge 1 ]]; do
  case "$1" in
    --version)
      version=1
      ;;
    -s|--kernel-name)
      kernel_name=1
      ;;
    -n|--nodename)
      nodename=1
      ;;
    -r|--kernel-release)
      kernel_release=1
      ;;
    -v|--kernel-version)
      kernel_version=1
      ;;
    -m|--machine)
      machine=1
      ;;
    -p|--processor)
      processor=1
      ;;
    -i|--hardware-platform)
      hardware_platform=1
      ;;
    -o|--operating-system)
      operating_system=1
      ;;
    -a|--all)
      all=1
      ;;
    --help)
      show_help
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "uname: unrecognized option '$1'"
      echo "Type 'uname --help' for a list of available options."
      exit 1
      ;;
  esac
  shift
done


KERNEL_NAME_VAL=@uSystem@
NODENAME_VAL=nixpkgs
KERNEL_RELEASE_VAL=@modDirVersion@
# #1-NixOS SMP PREEMPT_DYNAMIC Wed Dec 14 10:41:06 UTC 2022
KERNEL_VERSION_VAL="#1-NixOS Tue Jan 1 00:00:00 UTC 1980"
MACHINE_VAL=@processor@
PROCESSOR_VAL=unknown
HARDWARE_PLATFORM_VAL=unknown
OPERATING_SYSTEM_VAL=@operatingSystem@


if [[ "$version" = "1" ]]; then
    # in case some script greps for GNU coreutils.
    echo "uname (GNU coreutils) 9.1"
    echo "Nixpkgs deterministic-uname"
    exit
fi

# output of the real uname from GNU coreutils
# Darwin:
#  Darwin *nodename* 22.1.0 Darwin Kernel Version 22.1.0: Sun Oct  9 20:14:30 PDT 2022; root:xnu-8792.41.9~2/RELEASE_ARM64_T8103 arm64 arm Darwin
# NixOS:
#  Linux *nodename* 6.0.13 #1-NixOS SMP PREEMPT_DYNAMIC Wed Dec 14 10:41:06 UTC 2022 x86_64 GNU/Linux
output=()
if [[ "$all" = "1" ]]; then
    output+=("$KERNEL_NAME_VAL" "$NODENAME_VAL" "$KERNEL_RELEASE_VAL" "$KERNEL_VERSION_VAL" "$MACHINE_VAL")
    # in help:  except omit -p and -i if unknown.
    # output+=($PROCESSOR_VAL $HARDWARE_PLATFORM_VAL)
    output+=("$OPERATING_SYSTEM_VAL")
fi

if [[ "$kernel_name" = "1" ]]; then
    output+=("$KERNEL_NAME_VAL")
fi

if [[ "$nodename" = "1" ]]; then
    output+=("$NODENAME_VAL")
fi

if [[ "$kernel_release" = "1" ]]; then
    output+=("$KERNEL_RELEASE_VAL")
fi

if [[ "$kernel_version" = "1" ]]; then
    output+=("$KERNEL_VERSION_VAL")
fi

if [[ "$machine" = "1" ]]; then
    output+=("$MACHINE_VAL")
fi

if [[ "$processor" = "1" ]]; then
    output+=("$PROCESSOR_VAL")
fi

if [[ "$hardware_platform" = "1" ]]; then
    output+=("$HARDWARE_PLATFORM_VAL")
fi

if [[ "$operating_system" = "1" ]]; then
    output+=("$OPERATING_SYSTEM_VAL")
fi

echo "${output[@]}"
