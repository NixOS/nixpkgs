{ fetchgit, runCommand, makeWrapper, openssh, stdenv }: args: derivation ((fetchgit args).drvAttrs // {
  SSH_AUTH_SOCK = if (builtins.tryEval <ssh-auth-sock>).success
    then builtins.toString <ssh-auth-sock>
    else null;

  GIT_SSH = let
    config = ''${let
        sshConfigFile = if (builtins.tryEval <ssh-config-file>).success
          then <ssh-config-file>
          else builtins.trace ''
            Please set your nix-path such that ssh-config-file points to a file that will allow ssh to access private repositories. The builder will not be able to see any running ssh agent sessions unless ssh-auth-sock is also set in the nix-path.

            Note that the config file and any keys it points to must be readable by the build user, which depending on your nix configuration means making it readable by the build-users-group, the user of the running nix-daemon, or the user calling the nix command which started the build. Similarly, if using an ssh agent ssh-auth-sock must point to a socket the build user can access.

            You may need StrictHostKeyChecking=no in the config file. Since ssh will refuse to use a group-readable private key, if using build-users you will likely want to use something like IdentityFile /some/directory/%u/key and have a directory for each build user accessible to that user.
          '' "/var/lib/empty/config";
      in builtins.toString sshConfigFile}'';

    ssh-wrapped = runCommand "fetchgit-ssh" {
      buildInputs = [ makeWrapper ];
    } ''
      mkdir -p $out/bin
      makeWrapper ${openssh}/bin/ssh $out/bin/ssh --prefix PATH : "$out/bin" --add-flags "-F ${config}" "$@"
    '';
  in "${ssh-wrapped}/bin/ssh";
})
