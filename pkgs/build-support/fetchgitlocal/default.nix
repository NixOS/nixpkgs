{ runCommand, git }: src:

runCommand "local-git-export" {} ''
  cd ${toString src}
  mkdir -p "$out"
  for file in $(${git}/bin/git ls-files); do
    mkdir -p "$out/$(dirname $file)"
    cp -d $file "$out/$file" || true # don't fail when trying to copy a directory
  done
''
