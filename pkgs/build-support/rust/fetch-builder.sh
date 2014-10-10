source $stdenv/setup

# cargo-fetch needs to write to Cargo.lock, even to do nothing. We
# create a fake checkout with symlinks and and editable Cargo.lock.
mkdir copy
cd copy
for f in $(ls $src); do
  ln -s $src/"$f" .
done
rm Cargo.lock
cp $src/Cargo.lock .
chmod +w Cargo.lock

$fetcher . $out

cd ..
rm -rf copy
