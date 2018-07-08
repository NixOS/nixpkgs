# Helper functions for verifying (detached) PGP signatures

# importPublicKey
# Add PGP public key contained in ${publicKey} to the keyring.
# All imported keys will be trusted by verifySig
_importPublicKey() {
  if [ -z "$signaturePublicKey" ]; then
    echo "error: verifySignatureHook requires signaturePublicKey" >&2
    exit 1
  fi
  gpg -q --import "$signaturePublicKey"
}


# verifySignature SIGFILE DATAFILE UNCOMPRESS
# verify the signature SIGFILE for the file DATAFILE
# if DATAFILE is omitted, it is derived from SIGFILE by dropping the .asc or .sig suffix
# if UNCOMPRESS is set, uncompress DATAFILE before verification
verifySignature() {
  if [ -z "$3" ]; then
    gpgv --keyring pubring.kbx "$1" "$2" || exit 1
  else
    gunzip -c "$2" | gpgv --keyring pubring.kbx "$1" - || exit 1
  fi
}


# verifySrcSignature 
# verify the signature $srcSignature for source file $src
verifySrcSignature() {
  _importPublicKey
  [ -z "$srcSignature" ] && return
  verifySignature "$srcSignature" "$src" "$signatureUncompressed"
}


# setup

# create temporary gpg homedir
export GNUPGHOME=$(readlink -f .gnupgtmp)
rm -rf $GNUPGHOME # make sure it's a fresh empty dir
mkdir -p -m 700 $GNUPGHOME

# automatically check the signature before unpack if srcSignature is set
preUnpackHooks+=(verifySrcSignature)
