#! @shell@ -e

# Shows the usage of this command to the user

showUsage()
{
    echo "Usage: $0 network_expr"
    echo "Options:"
    echo
    echo "--no-out-link   Do not create a 'result' symlink"
    echo "--show-trace    Shows the output trace"
    echo "-h,--help       Shows the usage of this command"
}

# Parse valid argument options

PARAMS=`getopt -n $0 -o h -l no-out-link,show-trace,help -- "$@"`

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
	--no-out-link)
	    noOutLinkArg="--no-out-link"
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

shift

# Validate the given options

if [ "$1" = "" ]
then
    echo "ERROR: A network expression must be specified!" >&2
    exit 1
else
    networkExpr=$(readlink -f $1)
fi

# Build a network of VMs

nix-build '<nixos/modules/installer/tools/nixos-build-vms/build-vms.nix>' \
    --argstr networkExpr $networkExpr $noOutLinkArg $showTraceArg
