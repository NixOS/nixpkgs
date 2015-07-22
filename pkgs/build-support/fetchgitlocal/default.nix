{ runCommand, git, nix }: src:

let hash = import (runCommand "head-hash.nix"
  { dummy = builtins.currentTime;
    preferLocalBuild = true; }
''
  cd ${toString src}
  (${git}/bin/git show && ${git}/bin/git diff) > $out
  hash=$(${nix}/bin/nix-hash $out)
  echo "\"$hash\"" > $out
''); in

runCommand "local-git-export"
  { dummy = hash;
    preferLocalBuild = true; }
''
  cd ${toString src}
  mkdir -p "$out"
  for file in $(${git}/bin/git ls-files); do
    mkdir -p "$out/$(dirname $file)"
    cp -d $file "$out/$file" || true # don't fail when trying to copy a directory
  done
''
