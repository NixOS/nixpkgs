#! @shell@ -e

# Shows the usage of this command to the user

showUsage()
{
    echo "Usage: $0 -n network_expr -i infrastructure_expr"
    echo "Options:"
    echo
    echo "-n,--network        Network Nix expression which captures properties of machines in the network"
    echo "-i,--infrastructure Infrastructure Nix expression which captures properties of machines in the network"
    echo "-h,--help           Shows the usage of this command"
}

# Parse valid argument options

PARAMS=`getopt -n $0 -o n:i:h -l network:,infrastructure:,show-trace,help -- "$@"`

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
	-i|--infrastructure)
	    infrastructureExpr=`readlink -f $2`
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

if [ "$infrastructureExpr" = "" ]
then
    echo "ERROR: A infrastructure expression must be specified!" >&2
    exit 1
fi

if [ "$networkExpr" = "" ]
then
    echo "ERROR: A network expression must be specified!" >&2
    exit 1
fi

if [ -z "$NIXOS" ]
then
    NIXOS=/etc/nixos/nixos
fi

# Deploy the network

nix-build $NIXOS/deploy.nix --argstr networkExpr $networkExpr --argstr infrastructureExpr $infrastructureExpr $showTraceArg
./result/bin/deploy-systems
rm -f result
