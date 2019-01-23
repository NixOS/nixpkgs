{ vmTools
, runCommand
, utillinux
, cryptsetup
, kmod
}:

fileSystem:

vmTools.runInLinuxVM (runCommand "wrap-luks"
  {
    FILE_SYSTEM=fileSystem;

    nativeBuildInputs = [ utillinux cryptsetup kmod ];
    __impure = true;
  }
  ''
    BLOCKS=$(du -B 512 $(realpath $FILE_SYSTEM) | cut -d $'\t' -f1)

    modprobe loop

    rmdir $out
    fallocate -x -l $(( 512 * ($BLOCKS + 4096) )) $out

    # A Nix way to change the passphrase is purposely not added,
    # as the passphrase will be added to the /nix/store.
    # Instead, you can change the passphrase once the image is built.
    # See: https://askubuntu.com/a/384936
    cryptsetup luksFormat $out <<< PASSPHRASE
    cryptsetup luksOpen $out cryptbackup <<< PASSPHRASE

    dd if=$FILE_SYSTEM of=/dev/mapper/cryptbackup bs=512

    cryptsetup luksClose cryptbackup
  '')
