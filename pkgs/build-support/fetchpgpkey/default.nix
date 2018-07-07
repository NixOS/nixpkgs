# This function downloads a PGP public key and verifies its fingerprint
# Because it is based on fetchurl, it will still require a sha256
# in addition to the fingerprint

{ lib, fetchurl, gnupg }:

{
  fingerprint
, ... } @ args:

lib.overrideDerivation (fetchurl ({

  name = "pubkey-${fingerprint}";

  postFetch =
    ''
      # extract fingerprint
      fpr=$(cat "$downloadedFile" | gpg --homedir . --import --import-options show-only --with-colons 2>/dev/null | grep '^fpr' | cut -d: -f 10)
      # verify
      if [ "$fpr" == "${fingerprint}" ]; then
        echo "key fingerprint $fpr verified"
      else
        echo "key fingerprint mismatch: got $fpr, expected ${fingerprint}"
        exit 1
      fi
    '';

} // removeAttrs args [ "fingerprint" ] ))
(x: {nativeBuildInputs = x.nativeBuildInputs++ [gnupg];})
