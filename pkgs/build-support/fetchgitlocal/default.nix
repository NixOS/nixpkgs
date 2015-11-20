{ runCommand, git, nix }: src:

let
  srcStr = toString src;

  # Adds the current directory (respecting ignored files) to the git store, and returns the hash
  gitHashFile = runCommand "put-in-git" {
      nativeBuildInputs = [ git ];
      dummy = builtins.currentTime; # impure, do every time
      preferLocalBuild = true;
    } ''
      cd ${srcStr}
      ROOT=$(git rev-parse --show-toplevel) # path to repo

      cp $ROOT/.git/index $ROOT/.git/index-user # backup index
      git reset # reset index
      git add . # add current directory

      # hash of current directory
      # remove trailing newline
      git rev-parse $(git write-tree) \
        | tr -d '\n' > $out

      mv $ROOT/.git/index-user $ROOT/.git/index # restore index
    '';

  gitHash = builtins.readFile gitHashFile; # cache against git hash

  nixPath = runCommand "put-in-nix" {
      nativeBuildInputs = [ git ];
      preferLocalBuild = true;
    } ''
      mkdir $out

      # dump tar of *current directory* at given revision
      git -C ${srcStr} archive --format=tar ${gitHash} \
        | tar xvf - -C $out
    '';

in nixPath
