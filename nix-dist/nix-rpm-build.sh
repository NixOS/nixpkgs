#! /bin/sh

buildinputs="$getopt"
. $stdenv/setup || exit 1

# Set up a RPM macros file.  We have to use ~/.rpmmacros (`--rcfile'
# doesn't seem to work properly), so point HOME at the current
# directory.
export HOME=`pwd`
rpmmacros=$HOME/.rpmmacros

rpmdir=`pwd`/rpm

# Set up the directory structure expected by RPM.
mkdir $rpmdir || exit 1
mkdir $rpmdir/BUILD || exit 1
mkdir $rpmdir/SOURCE || exit 1
mkdir $rpmdir/SPECS || exit 1
mkdir $rpmdir/RPMS || exit 1
mkdir $rpmdir/SRPMS || exit 1

echo "%_topdir $rpmdir" > $rpmmacros

# Do the build.
$rpm -ta $src/*.tar.gz || exit 1

# Copy the resulting RPMs.
mkdir $out || exit 1
cp -p $rpmdir/RPMS/*/* $out || exit 1
