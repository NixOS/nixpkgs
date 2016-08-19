source $stdenv/setup
header "Cloning Fossil $url into $out"

# Fossil, bless its adorable little heart, wants to write global configuration
# to $HOME/.fossil. AFAICT, there is no way to disable this functionality.
export HOME=.

# We must explicitly set the admin user for the clone to something reasonable.
fossil clone -A nobody "$url" fossil-clone.fossil

mkdir fossil-clone
WORKDIR=$(pwd)
mkdir $out
pushd $out
fossil open "$WORKDIR/fossil-clone.fossil"
popd

# Just nuke the checkout file.
rm $out/.fslckout

stopNest
