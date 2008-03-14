# This is needed by curl.
echo "adding /usr/kerberos/lib to ld.so.conf..."
echo "/usr/kerberos/lib" >> $root/etc/ld.so.conf
chroot $root /sbin/ldconfig
