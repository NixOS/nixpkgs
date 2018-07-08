# Helper functions for verifying php signatures

# importPublicKey
# Add PGP public key contained in ${publicKey} to the keyring.
# All imported keys will be trusted by verifySig
_importPublicKey() {
  if [ -z "${publicKey}" ]; then
    echo "error: publicKey must be defined when using verifySignatureHook" >&2
    exit 1
  fi
  gpg -q --import "${publicKey}"
}


# verifySignature SIGFILE DATAFILE
# verify the signature SIGFILE for the file DATAFILE
# if DATAFILE is omitted, it is derived from SIGFILE by dropping the .asc or .sig suffix
verifySignature() {
  gpgv --keyring pubring.kbx "$1" "$2" || exit 1
}

# create temporary gpg homedir
export GNUPGHOME=$(readlink -f .gnupgtmp)
rm -rf $GNUPGHOME # make sure it's a fresh empty dir
mkdir -p -m 700 $GNUPGHOME

preUnpackHooks+=(_importPublicKey)
