#! @shell@ -e

# Shows the usage of this command to the user

showUsage()
{
    echo "Usage: $0 network_expr"
    echo "Options:"
    echo
    echo "--show-trace  Shows an output trace"
    echo "--no-out-link Do not create a 'result' symlink"
    echo "-h,--help     Shows the usage of this command"
}

# Parse valid argument options

PARAMS=`getopt -n $0 -o h -l show-trace,no-out-link,help -- "$@"`

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
	--show-trace)
	    showTraceArg="--show-trace"
	    ;;
	--no-out-link)
	    noOutLinkArg="--no-out-link"
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

if [ -z "$NIXOS" ]
then
    NIXOS=/etc/nixos/nixos
fi

if [ "$@" = "" ]
then
    echo "ERROR: A network Nix expression must be specified!" >&2
    exit 1
else
    networkExpr=$(readlink -f $@)
fi

# Deploy the network

vms=`nix-build $NIXOS/modules/installer/tools/nixos-deploy-network/deploy.nix --argstr networkExpr $networkExpr --argstr nixos $NIXOS $showTraceArg $noOutLinkArg`
$vms/bin/deploy-systems
