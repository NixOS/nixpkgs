{ runCommand, git }: src:

runCommand "local-git-export" {} ''
  cd ${src}
  mkdir -p "$out"
  for file in $(${git}/bin/git ls-files); do
    mkdir -p "$out/$(dirname $file)"
    cp -d $file "$out/$file"
  done
''
