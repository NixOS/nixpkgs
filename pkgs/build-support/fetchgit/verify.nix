{
  lib,
  runCommand,
  writeShellApplication,
  writeText,
  git,
  openssh,
  gnupg,
}:
(
  {
    name,
    revWithTag,
    verifyCommit,
    verifyTag,
    publicKeys,
    leaveDotGit,
    fetchresult,
  }:
  let
    # split gpg keys from ssh keys
    keysPartitioned = lib.partition (k: k.type == "gpg") publicKeys;
    gpgKeys = lib.catAttrs "key" keysPartitioned.right;
    sshKeys = keysPartitioned.wrong;
    # create a keyring containing gpgKeys
    gpgKeyring = runCommand "gpgKeyring" { buildInputs = [ gnupg ]; } ''
      gpg --homedir /build --no-default-keyring --keyring $out --fingerprint    # create empty keyring at $out
      for KEY in ${lib.concatStringsSep " " gpgKeys}
      do
        gpg --homedir /build --no-default-keyring --keyring $out --import $KEY  # import $KEY
      done
    '';
    # wrap gpg to use gpgKeyring
    gpgWithKeys = writeShellApplication {
      name = "gpgWithKeys";
      runtimeInputs = [ gnupg ];
      text = ''
        gpg --homedir /build --no-default-keyring --always-trust --keyring ${gpgKeyring} "$@"
      '';
    };
    # create "allowed signers" file for ssh key verification: https://man.openbsd.org/ssh-keygen.1#ALLOWED_SIGNERS
    allowedSignersFile = writeText "allowed signers" (
      lib.concatMapStrings (k: "* ${k.type} ${k.key}\n") sshKeys
    );
  in
  runCommand name
    {
      buildInputs = [
        git
        openssh
        gpgWithKeys
      ];
      inherit verifyCommit verifyTag leaveDotGit;
    }
    ''
      if test "$verifyCommit" == 1; then
          git \
            -c gpg.ssh.allowedSignersFile="${allowedSignersFile}" \
            -c safe.directory='*' \
            -c gpg.program="gpgWithKeys" \
            -C "${fetchresult}" \
            verify-commit ${revWithTag}
      fi

      if test "$verifyTag" == 1; then
          git \
            -c gpg.ssh.allowedSignersFile="${allowedSignersFile}" \
            -c safe.directory='*' \
            -c gpg.program="gpgWithKeys" \
            -C "${fetchresult}" \
            verify-tag ${revWithTag}
      fi

      if test "$leaveDotGit" != 1; then
          cp -r --no-preserve=all "${fetchresult}" $out
          rm -rf "$out"/.git
      else
          ln "${fetchresult}" $out
      fi
    ''
)
