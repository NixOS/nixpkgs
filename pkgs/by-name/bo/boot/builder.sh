boot_bin=$out/bin/boot

mkdir -pv $(dirname $boot_bin)
cp -v $src $boot_bin
chmod -v 755 $boot_bin

patchShebangs $boot_bin

sed -i \
    -e "s;\${BOOT_JAVA_COMMAND:-java};\${BOOT_JAVA_COMMAND:-${jdk}/bin/java};g" \
    $boot_bin
