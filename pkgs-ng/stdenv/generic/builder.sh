#! /bin/sh

# Set up the initial path.
for i in $initialPath; do
    PATH=$PATH:$i/bin
done

# Make output directories.
mkdir $out || exit 1
mkdir $out/bin || exit 1

# Create the setup script.
sed \
 -e "s^@OUT@^$out^g" \
 -e "s^@PREHOOK@^$prehook^g" \
 -e "s^@POSTHOOK@^$posthook^g" \
 -e "s^@INITIALPATH@^$initialPath^g" \
 -e "s^@PARAM1@^$param1^g" \
 -e "s^@PARAM2@^$param2^g" \
 -e "s^@PARAM3@^$param3^g" \
 -e "s^@PARAM4@^$param4^g" \
 -e "s^@PARAM5@^$param5^g" \
 < $setup > $out/setup || exit 1

# Create the gcc wrapper.
sed \
 -e 's^@GCC\@^$NIX_CC^g' \
 < $gccwrapper > $out/bin/gcc || exit 1
chmod +x $out/bin/gcc || exit 1
ln -s gcc $out/bin/cc || exit 1

# Create the g++ wrapper.
sed \
 -e 's^@GCC\@^$NIX_CXX^g' \
 < $gccwrapper > $out/bin/g++ || exit 1
chmod +x $out/bin/g++ || exit 1
ln -s g++ $out/bin/c++ || exit 1

# Create the ld wrapper.
cp $ldwrapper $out/bin/ld || exit 1
chmod +x $out/bin/ld || exit 1
