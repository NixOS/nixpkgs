{ runCommand, git, nix }: src:

let
  tmpFolder =  "/tmp/fetchgitlocal-${builtins.toString currentTime}";
  currentTime = builtins.currentTime; # impure, do every time

  srcStr = toString src;

  # Adds the current directory in the index (respecting ignored files) to the git store,
  # and returns the hash
  gitHashFile = runCommand "put-in-git" {
      nativeBuildInputs = [ git ];
      dummy = currentTime;
      preferLocalBuild = true;
    } ''
      # we need write access to update index
      cp -r ${srcStr}/.git ${tmpFolder}
      chmod a+w ${tmpFolder}
      export GIT_DIR=${tmpFolder}

      # `tr` to remove trailing newline
      res="$(git rev-parse --show-prefix)"
      git write-tree --prefix="$res" | tr -d '\n' > $out
    '';

  gitHash = builtins.readFile gitHashFile; # cache against git hash

  nixPath = runCommand "put-in-nix" {
      nativeBuildInputs = [ git ];
      preferLocalBuild = true;
    } ''
      mkdir $out

      # git annoyingly breaks without doing this since the hash does
      # not correspond to repo root.
      cd $(git -C ${srcStr} rev-parse --show-toplevel)

      # dump tar of *current directory* at given revision
      hash="${gitHash}"
      git archive --format=tar $hash | tar xv -C $out
    '';

in nixPath
