#! @shell@ -e

mkdir -p /var/elliptic-keys
chmod 0755 /var/elliptic-keys
cd /var/elliptic-keys
touch private
chmod 0700 private
dd if=/dev/urandom bs=128 count=1 of=private
chmod 0500 private
public=$(seccure-key -F private 2>&1)
echo ${public#*The public key is: } > public
chmod 0555 public

