#! @shell@ -e

# Shows the usage of this command to the user

showUsage()
{
    echo "Usage: $0 -n network_expr -i infrastructure_expr"
    echo "Options:"
    echo
    echo "-n,--network        Network Nix expression which captures properties of machines in the network"
    echo "--use-backdoor      Indicates that the backdoor must be enabled so that the VMs can be accessed through a UNIX domain socket" 
    echo "--show-trace        Shows the output trace"
    echo "-h,--help           Shows the usage of this command"
}

# Parse valid argument options

PARAMS=`getopt -n $0 -o n:h -l network:,use-backdoor,show-trace,help -- "$@"`

if [ $? != 0 ]
then
    showUsage
    exit 1
fi

eval set -- "$PARAMS"

# Evaluate valid options

while [ "$1" != "--" ]
do
    case "$1" in
	-n|--network)
	    networkExpr=`readlink -f $2`
	    ;;
	--use-backdoor)
	    useBackdoorArg="--arg useBackdoor true"
	    ;;
	--show-trace)
	    showTraceArg="--show-trace"
	    ;;
	-h|--help)
	    showUsage
	    exit 0
	    ;;
    esac
    
    shift
done

# Validate the given options

if [ "$networkExpr" = "" ]
then
    echo "ERROR: A network expression must be specified!" >&2
    exit 1
fi

if [ -z "$NIXOS" ]
then
    NIXOS=/etc/nixos/nixos
fi

# Build a network of VMs

nix-build $NIXOS/modules/installer/tools/nixos-build-vms/build-vms.nix --argstr networkExpr $networkExpr --argstr nixos $NIXOS --argstr nixpkgs $NIXPKGS_ALL $useBackdoorArg $showTraceArg
