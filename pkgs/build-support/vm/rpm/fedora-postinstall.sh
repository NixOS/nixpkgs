# Add missing symlink to /lib/libssl.so.0.9.7a (or similar).  Curl
# needs it.
echo "adding libssl symlink..."
chroot $root /bin/sh -c "/bin/ln -v -s /lib/libssl.so.* /lib/libssl.so.4"
chroot $root /bin/sh -c "/bin/ln -v -s /lib/libcrypto.so.* /lib/libcrypto.so.4"
